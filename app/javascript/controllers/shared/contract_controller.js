import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--contract"
export default class extends Controller {
  static targets = [
    "interestPeriodNote",
    "interestPeriodUnit",
    "interestUnit",
    "interestFieldsWrapper",
    "interestMethodSelect",
    "assetTypeSelect",
    "assetNameInput",
    "interestRateInput",
    "interestPeriodInput",
    "contractTermUnit",
    "contractTermDaysInput"
  ]

  connect() {
    const data = { attributes: { code: this.interestMethodSelectTarget.value } };
    this.handleInterestWrapperVisibility(data);
    this.fetchAssetTypeDefault();
  }

  async handleInterestMethodChange(event) {
    try {
      const selectedValue = event.target.value;
      const request = new FetchRequest('get', `/interest_calculation_methods/${selectedValue}`, {
        responseKind: 'turbo-stream',
      });
      const { response } = await request.perform();
      if (response.ok) {
        const data = await response.json();
        this.setInterestMethodDetails(data);
        this.handleInterestWrapperVisibility(data);
      } else {
        alertController.show('Không thể lấy thông tin hình thức lãi', 'error');
      }
    } catch {
      alert('Đã có lỗi xảy ra, vui lòng thử lại sau!');
    }
  }

  async fetchAssetTypeDefault() {
    const assetTypeSelect = document.getElementById("select-asset-type");
    if (!assetTypeSelect) return;

    this.handleAssetTypeChange(true);
  }

  async handleAssetTypeChange() {
    try {
      const selectedAssetTypeId = this.assetTypeSelectTarget.value;
      const request = new FetchRequest('get', `/asset_settings/${selectedAssetTypeId}`, {
        responseKind: 'json',
      });
      const { response } = await request.perform();
      if (response.ok) {
        const data = await response.json();
        const attributes = data.data.attributes;
        this.interestRateInputTarget.value = attributes.default_interest_rate || "";
        this.interestPeriodInputTarget.value = attributes.interest_period || "";
        this.interestMethodSelectTarget.value = attributes.interest_calculation_method || "";
        this.contractTermDaysInputTarget.value = attributes.default_contract_term || "";
      } else {
        alertController.show('Không thể lấy thông tin loại tài sản', 'error');
      }
    } catch {
      alertController.show('Không thể lấy thông tin loại tài sản', 'error');
    }
  }

  async fetchAssetAttributes() {
    const request = new FetchRequest('get', `/contracts/asset_attributes/${this.assetTypeSelectTarget.value}`, {
      responseKind: 'turbo-stream',
    });

    await request.perform();
  }

  setInterestMethodDetails(data) {    
    this.interestUnitTarget.textContent = data.attributes.percent_unit;
    this.interestPeriodUnitTarget.textContent = data.attributes.unit;
    this.contractTermUnitTarget.textContent = data.attributes.unit;
    this.interestPeriodNoteTarget.textContent = data.attributes.note;
    this.contractTermDaysInputTarget.placeholder = data.attributes.placeholder || "";
  }

  handleInterestWrapperVisibility(data) {
    if (data.attributes.code === "investment_capital") {
      this.interestFieldsWrapperTarget.classList.add("hidden");
    } else {
      this.interestFieldsWrapperTarget.classList.remove("hidden");
    }
  }
}
