import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--additional-loan"
export default class extends Controller {
  static values = {
    cancelUrl: String,
    contractId: String,
  };

  async cancelAdditionalLoan() {
    try {
      const form = new FormData();
      form.append("form[contract_id]", this.contractIdValue);

      const request = new FetchRequest('DELETE', this.cancelUrlValue, {
        responseKind: 'turbo-stream',
        body: form,
      });

      await request.perform();

      // Close the alert dialog
      const btnCancelReduction = document.getElementById("btn-cancel-additional-loan");
      btnCancelReduction.click();
    } catch (error) {
      console.error(error);
      alertController.show('Không thể huỷ thanh toán', 'error');
    }
  }
}