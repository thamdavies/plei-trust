import { Controller } from '@hotwired/stimulus';
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--reminder"
export default class extends Controller {
  async cancel() {
    const formElement = document.getElementById("reminder-form");
    if (!formElement) {
      alertController.show("Không tìm thấy biểu mẫu hẹn giờ.", "error");
      return;
    }

    const contractIdInput = formElement.querySelector('input[name="form[contract_id]"]');
    if (!contractIdInput || !contractIdInput.value) {
      alertController.show("ID hợp đồng không hợp lệ.", "error");
      return;
    }

    const formData = new FormData(formElement);

    const request = new FetchRequest('DELETE', `/contracts/reminders/${contractIdInput.value}`, {
      responseKind: 'turbo-stream',
      body: formData
    });

    await request.perform();
  }
}
