import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
import { alertController } from "../../alert";

// Connects to data-controller="shared--customer"
export default class extends Controller {
  static targets = ['remover']

  connect() {
    window.addEventListener("autocomplete.change", this.autocompleteChange.bind(this))
  }

  disconnect() {
    window.removeEventListener("autocomplete.change", this.autocompleteChange.bind(this))
  }

  autocompleteChange(event) {
    console.log(this.removerTarget);
    const { value, textValue, selected } = event.detail
    const input = this.element.querySelector("input[data-autocomplete-target='input']")
    if (input) {
      input.readOnly = true
      this.removerTarget.classList.remove("hidden")
    }
  }

  clearSelection() {
    const input = this.element.querySelector("input[data-autocomplete-target='input']")
    if (input) {
      input.readOnly = false
      input.value = ""
      this.removerTarget.classList.add("hidden")
    }
  }
}
