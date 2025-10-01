import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from '@rails/request.js';
// import { alertController } from "../../alert";

// Connects to data-controller="shared--customer"
export default class extends Controller {
  static targets = [
    "remover",
    "fullNameInput",
    "customerIdInput",
    "nationalIdInput",
    "phoneInput",
    "issueDateInput",
    "issuePlaceInput",
    "addressInput"
  ]

  connect() {
    window.addEventListener("autocomplete.change", this.autocompleteChange.bind(this))
  }

  disconnect() {
    window.removeEventListener("autocomplete.change", this.autocompleteChange.bind(this))
  }

  async autocompleteChange(event) {
    console.log("Customer selected:", event.detail);
    
    const { value: customerId } = event.detail
    const input = this.element.querySelector("input[data-autocomplete-target='input']")
    if (input) {
      input.readOnly = true
      this.removerTarget.classList.remove("hidden")
    }

    // Get customer details from server
    if (customerId) {
      await this.fetchCustomerDetails(customerId)
    }
  }

  async fetchCustomerDetails(customerId) {
    const request = new FetchRequest('get', `/autocomplete/customers/${customerId}`);
    const { response } = await request.perform();

    if (response.ok) {
      const data = await response.json()
      const customer = data.data.attributes
      const formatDate = (dateStr) => {
        if (!dateStr) return "";
        const date = new Date(dateStr);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
      };

      this.fullNameInputTarget.value = customer.full_name || ""
      this.customerIdInputTarget.value = customer.id || ""
      this.nationalIdInputTarget.value = customer.national_id || ""
      this.phoneInputTarget.value = customer.phone || ""
      if (customer.national_id_issued_date) {
        this.issueDateInputTarget.value = formatDate(customer.national_id_issued_date)
      } else {
        this.issueDateInputTarget.value = ""
      }
      this.issuePlaceInputTarget.value = customer.national_id_issued_place || ""
      this.addressInputTarget.value = customer.address || ""
    }
  }

  clearSelection() {
    const input = this.element.querySelector("input[data-autocomplete-target='input']")
    if (input) {
      input.readOnly = false
      this.resetInfo()
      this.removerTarget.classList.add("hidden")
    }
  }

  resetInfo() {
    this.fullNameInputTarget.value = ""
    this.customerIdInputTarget.value = ""
    this.nationalIdInputTarget.value = ""
    this.phoneInputTarget.value = ""
    this.issueDateInputTarget.value = ""
    this.issuePlaceInputTarget.value = ""
    this.addressInputTarget.value = ""
  }
}
