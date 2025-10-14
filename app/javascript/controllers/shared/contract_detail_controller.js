import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--contract-detail"
export default class extends Controller {
  static targets = [
    "customerPaymentAmountInput"
  ]

  async togglePaid(event) {
    try {
      const { id, checked, dataset } = event.target;
      const form = new FormData();
      form.append(`form[id]`, id);
      form.append(`form[contract_id]`, dataset.contractId);
      if (checked) {
        form.append(`form[total_paid]`, this.customerPaymentAmountInputTarget.value.replace(/\./g, ''));
      }

      const request = new FetchRequest('patch', `/contracts/interest_payments/${id}`, {
        responseKind: 'turbo-stream',
        body: form,
      });

      await request.perform();
    } catch (error) {
      console.error("Error updating payment status:", error);
      alertController.show('Không thể cập nhật trạng thái thanh toán', 'alert');
    }
  }
}