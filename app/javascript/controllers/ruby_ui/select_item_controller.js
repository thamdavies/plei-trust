import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static values = { selected: String };

  connect() {
    if (this.element.dataset.value == this.selectedValue) {
      this.element.setAttribute("aria-selected", true);
    } else {
      this.element.removeAttribute("aria-selected");
    }
  }

  handleSelectItem({ target }) {
    if (this.element.dataset.value == target.dataset.value) {
      this.element.setAttribute("aria-selected", true);
    } else {
      this.element.removeAttribute("aria-selected");
    }
  }
}
