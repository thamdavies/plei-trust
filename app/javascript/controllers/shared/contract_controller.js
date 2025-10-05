import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--contract"
export default class extends Controller {
  static targets = [
    "interestPeriodUnit",
    "interestUnit",
    "interestFieldsWrapper",
    "interestMethodSelect",
    "interestRateInput",
    "interestPeriodInput",
    "contractTermDaysInput"
  ]

  connect() {
    const data = { attributes: { code: this.interestMethodSelectTarget.value } };
    this.handleInterestWrapperVisibility(data);
  }

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
    this.interestPeriodUnitTarget.textContent = data.attributes.note;
    this.interestRateInputTarget.placeholder = data.attributes.placeholder || "";
    this.contractTermDaysInputTarget.placeholder = data.attributes.placeholder || "";
    this.handleInterestWrapperVisibility(data);
  }

  handleInterestWrapperVisibility(data) {
    if (data.attributes.code === "investment_capital") {
      this.interestFieldsWrapperTarget.classList.add("hidden");
    } else {
      this.interestFieldsWrapperTarget.classList.remove("hidden");
    }
  }
}
