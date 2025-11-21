import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--pdf"
export default class extends Controller {
  static values = {
    contractTypeCode: String,
    contractId: String,
    interestPaymentId: String,
    isPaid: Boolean
  }

  async printContractInfo() {
    const formElement = document.getElementById("contract-form");
    if (!formElement) {
      alertController.show("Không tìm thấy biểu mẫu hợp đồng.", "error");
      return;
    }

    const formData = new FormData(formElement);
    formData.append("contract_type_code", this.contractTypeCodeValue);

    const request = new FetchRequest('POST', '/pdfs/contracts', {
      responseKind: 'json',
      body: formData
    });

    const { response } = await request.perform();
    if (response.ok) {
      const data = await response.json();
      if (!data) return;

      window.open(`/pdfs/contracts/${data.activity_id}`, 'popup', 'width='+screen.width + 'height='+screen.height)
    } else {
      throw new Error('Something went wrong');
    }
  }

  async printReceipt() {
    if (!this.isPaidValue) {
      alertController.show("Chưa đóng lãi, không thể in biên nhận.", "alert");
      return;
    }

    window.open(`/pdfs/interest_payments/${this.interestPaymentIdValue}?contract_id=${this.contractIdValue}`, 'popup', 'width='+screen.width + 'height='+screen.height)
  }
}
