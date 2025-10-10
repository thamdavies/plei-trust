import { Controller } from "@hotwired/stimulus";
// import { FetchRequest } from '@rails/request.js';
// import { alertController } from "../../alert";

// Connects to data-controller="shared--custom-interest-payment"
export default class extends Controller {
  connect() {
    console.log("Custom interest payment controller connected");
  }

  resetForm() {
    console.log("Resetting form");
  }
}