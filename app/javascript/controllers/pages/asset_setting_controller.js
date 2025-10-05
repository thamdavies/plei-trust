import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="page--asset-setting"
export default class extends Controller {
  static targets = ["interestUnit", "interestPeriodUnit", "contractTermDaysInput"];

  async handleInterestMethodChange(event) {
    try {
      const selectedValue = event.target.value;
      const request = new FetchRequest('get', `/interest_calculation_methods/${selectedValue}`, {
        responseKind: 'turbo_stream',
      });
      const { response } = await request.perform();
      if (response.ok) {
        const data = await response.json();
        this.setInterestMethodDetails(data);
      } else {
        alertController.show('Không thể lấy thông tin hình thức lãi', 'alert');
      }
    } catch {
      alert('Đã có lỗi xảy ra, vui lòng thử lại sau!');
    }
  }

  setInterestMethodDetails(data) {
    this.interestUnitTarget.textContent = data.attributes.percent_unit;
    this.contractTermDaysInputTarget.placeholder = data.attributes.placeholder || "";
    this.interestPeriodUnitTarget.textContent = data.attributes.note;
  }
}
