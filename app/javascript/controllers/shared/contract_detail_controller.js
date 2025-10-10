import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--contract-detail"
export default class extends Controller {
  connect() {
    console.log("Contract detail controller connected");
  }

  async togglePaid(event) {
    try {
      const { id } = event.target;
      const request = new FetchRequest('patch', '/contracts/interest_payments', {
        responseKind: 'turbo_stream',
        body: JSON.stringify({ id }),
      });

      await request.perform();
    } catch {
      alertController.show('Không thể cập nhật trạng thái thanh toán', 'alert');
    }
  }
}