import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  connect() {
    this.boundHide = this.hide.bind(this)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    if (!this.menuTarget.classList.contains("hidden")) {
      // Use a timeout to ensure the click event that triggered the toggle doesn't immediately trigger the hide
      setTimeout(() => {
        document.addEventListener("click", this.boundHide)
      }, 0)
    } else {
      document.removeEventListener("click", this.boundHide)
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      document.removeEventListener("click", this.boundHide)
    }
  }

  disconnect() {
    document.removeEventListener("click", this.boundHide)
  }
}
