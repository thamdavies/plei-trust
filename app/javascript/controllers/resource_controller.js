import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';

// Connects to data-controller="resource"
export default class extends Controller {
  static values = {
    path: String,
    dialogbutton: String
  };

  triggerDialog(event) {
    event.preventDefault();
    const dialogButton = document.getElementById(this.dialogbuttonValue);
    if (dialogButton) {
      dialogButton.click();
      this.requestTurboFrame();
    } else {
      console.error(`Element with ID '${this.dialogbuttonValue}' not found.`);
    }
  }

  async requestTurboFrame() {
    if (!this.pathValue) return;

    const request = new FetchRequest('get', this.pathValue, {
      responseKind: 'turbo_stream',
    });
    await request.perform();
  }
}
