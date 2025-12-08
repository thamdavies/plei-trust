class Views::Shared::Contracts::Tabs::File::ContractFileForm < Views::Base
  def initialize(contract:, form: nil)
    @contract = contract.reload
    ctx = ContractFile::Operations::Create::Present.call(params: form_params.to_h)
    @form = ctx[:"contract.default"]
    @form.files = contract.blobs
  end

  def form_params
    { files: [], contract_id: contract.id }
  end

  def view_template
    div(class: "rounded-lg p-2 bg-background") do
      div(class: "flex items-center gap-2 mb-4") do
        Remix::Upload2Line(class: "w-5 h-5 text-yellow-600")
        h3(class: "text-lg font-semibold text-gray-900 dark:text-white") { "Upload ảnh chứng từ hợp đồng" }
      end

      div(class: "space-y-4") do
        # Dropzone form
        render_dropzone_form
      end
    end
  end

  private

  attr_reader :contract, :form

  def render_dropzone_form
    Form(action: form_url, method: "post") do
      input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      input(type: "hidden", name: "form[contract_id]", value: contract.id)

      div(class: "dropzone dropzone-default dz-clickable",
        data: {
          controller: "dropzone",
          dropzone_max_file_size: Settings.max_contract_file_size,
          dropzone_max_files: Settings.max_number_of_file_uploads,
          dropzone_accepted_files: "image/*",
          dropzone_remove_file_base_url: Settings.remove_contract_file_base_url,
          dropzone_blobs: form.files.to_json
        }
      ) do
        input(
          type: "file",
          name: "form[files][]",
          multiple: true,
          class: "hidden",
          data: {
            dropzone_target: "input",
            "direct-upload-url": rails_direct_uploads_url
          }
        )

        div(class: "dropzone-msg dz-message needsclick text-gray-600") do
          div(class: "flex flex-col items-center justify-center pt-5 pb-6") do
            Remix::UploadCloud2Line(class: "w-8 h-8 mb-4 text-gray-500 dark:text-gray-400")
            p(class: "mb-2 text-gray-500 dark:text-gray-400") { "Thả tệp vào đây hoặc nhấp để tải lên" }
            p(class: "text-sm") { "Chỉ cho phép tải lên tệp hình ảnh" }
          end
        end
      end

      div(class: "flex items-center justify-center mt-5") do
        Button(type: :submit) { "Tải lên" }
      end
    end
  end

  def form_url
    contracts_files_path
  end
end
