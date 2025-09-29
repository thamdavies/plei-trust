import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--contract"
export default class extends Controller {
  connect() {
    console.log("Shared: Contract controller connected");
  }
}
