import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="page--branch"
export default class extends Controller {
  async fetchWards(event) {
    try {
      const selectedValue = event.target.value;
      const request = new FetchRequest('get', `/wards?province_code=${selectedValue}`, {
        responseKind: 'turbo-stream',
      });
      const { response } = await request.perform();
      if (!response.ok) {
        alertController.show('Không thể lấy thông tin quận/huyện', 'error');
      } else {
        // Set all elements with name="form[ward_id]" to unchecked
        const wardElements = document.getElementsByName("form[ward_id]");
        wardElements.forEach((element) => {
          element.value = '';
        });
      }
    } catch {
      alert('Đã có lỗi xảy ra, vui lòng thử lại sau!');
    }
  }
}
