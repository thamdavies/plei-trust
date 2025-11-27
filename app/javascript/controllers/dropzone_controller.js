import Dropzone from "dropzone";
import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter
} from "../helpers/index";
import { FetchRequest } from "@rails/request.js";

export default class extends Controller {
  static targets = ["input"];
  static values = ["files"];

  connect() {
    this.dropZone = createDropZone(this);
    this.hideFileInput();
    this.bindEvents();
    Dropzone.autoDiscover = false; // necessary quirk for Dropzone error in console
    setTimeout(() => {
      this.displayExistingFile();
    }, 100);
  }

  displayExistingFile() {
    const blobs = JSON.parse(this.blobs);

    if (!blobs) return;

    for (let blob of blobs) {
      const mockFile = { id: blob.id, name: blob.filename, size: blob.byte_size, signed_id: blob.signed_id, remove_url: blob.remove_url };
      this.dropZone.displayExistingFile(mockFile, blob.url);
    }
  }

  get blobs() {
    return this.data.get("blobs");
  }

  // Private
  hideFileInput() {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = "none";
  }

  bindEvents() {
    this.dropZone.on("addedfile", file => {
      setTimeout(() => {
        console.log(file);
        
        if (file.remove_url) return; // Skip existing files

        file.accepted && createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropZone.on("removedfile", async (file) => {
      // Skip removal for files that don't have a controller (existing files that weren't uploaded)
      let removeUrl;
      if (file.controller) {
        removeElement(file.controller.hiddenInput);
        const controllerEl = file.controller.hiddenInput.parentElement;
        removeUrl = controllerEl.dataset.dropzoneRemoveFileBaseUrl.replace(':ID', file.controller.hiddenInput.value);
      } else {
        removeUrl = file.remove_url.replace(':ID', file.signed_id);
        const input = document.querySelector(`input[value='${file.signed_id}']`)
        input && removeElement(input)
      }

      const request = new FetchRequest('DELETE', removeUrl, {
        responseKind: 'json',
      });
      await request.perform();
    });


    this.dropZone.on("canceled", file => {
      file.controller && file.controller.xhr.abort();
    });
  }

  get headers() {
    return { "X-CSRF-Token": getMetaValue("csrf-token") };
  }

  get url() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }

  get maxFiles() {
    return this.data.get("maxFiles") || 1;
  }

  get maxFileSize() {
    return this.data.get("maxFileSize") || 256;
  }

  get acceptedFiles() {
    return this.data.get("acceptedFiles");
  }

  get addRemoveLinks() {
    return this.data.get("addRemoveLinks") || true;
  }

  get removeFileBaseUrl() {
    return this.data.get("removeFileBaseUrl");
  }
}

class DirectUploadController {
  constructor(source, file) {
    this.directUpload = createDirectUpload(file, source.url, this);
    this.source = source;
    this.file = file;
  }

  start() {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput);
        this.emitDropzoneError(error);
      } else {
        this.hiddenInput.value = attributes.signed_id;
        this.emitDropzoneSuccess();
      }
    });
  }

  createHiddenInput() {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.source.inputTarget.name;
    input.value = this.file.signed_id;
    insertAfter(input, this.source.inputTarget);
    return input;
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr);
    this.emitDropzoneUploading();
  }

  bindProgressEvent(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener("progress", event =>
      this.uploadRequestDidProgress(event)
    );
  }

  uploadRequestDidProgress(event) {
    // const element = this.source.element;
    const progress = (event.loaded / event.total) * 100;
    findElement(
      this.file.previewTemplate,
      ".dz-upload"
    ).style.width = `${progress}%`;
  }

  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING;
    this.source.dropZone.emit("processing", this.file);
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR;
    this.source.dropZone.emit("error", this.file, error);
    this.source.dropZone.emit("complete", this.file);
  }

  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS;
    this.source.dropZone.emit("success", this.file);
    this.source.dropZone.emit("complete", this.file);
  }
}

function createDirectUploadController(source, file) {
  return new DirectUploadController(source, file);
}

function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller);
}

function createDropZone(controller) {
  const instance = new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
    dictRemoveFile: "Xoá",
    dictMaxFilesExceeded: "Đã vượt quá số tệp cho phép",
    dictFileTooBig: "Tập tin quá lớn ({{filesize}}MiB). Dung lượng tối đa: {{maxFilesize}}MiB.",
    dictCancelUpload: "Hủy tải lên",
    dictResponseError: "Máy chủ trả về mã lỗi {{statusCode}}.",
    dictInvalidFileType: "Bạn không thể tải lên tập tin loại này.",
    dictFallbackMessage: "Trình duyệt của bạn không hỗ trợ tải tập tin bằng cách kéo thả. Xin vui lòng sử dụng mẫu đăng ký bên dưới.",
    dictRemoveFileConfirmation: "Bạn có chắc chắc muốn xoá tệp này?"
  });

  const { displayExistingFile } = instance;
  instance.displayExistingFile = function (mockFile, imageUrl, callback, crossOrigin, resizeThumbnail) {
    // @see https://github.com/dropzone/dropzone/pull/2003
    mockFile.accepted = true;
    mockFile.status = Dropzone.SUCCESS;
    displayExistingFile.call(this, mockFile, imageUrl, callback, crossOrigin, resizeThumbnail);
    this.files.push(mockFile);
    this._updateMaxFilesReachedClass();
  };

  return instance
}