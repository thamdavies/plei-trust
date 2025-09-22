import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
    this.handleWheel = this.handleWheel.bind(this)
    
    this.element.addEventListener('keydown', this.handleKeydown)
    this.element.addEventListener('wheel', this.handleWheel, { passive: false })
  }

  disconnect() {
    this.element.removeEventListener('keydown', this.handleKeydown)
    this.element.removeEventListener('wheel', this.handleWheel)
  }

  handleKeydown(event) {
    if (event.key === "ArrowUp" || event.key === "ArrowDown") {
      event.preventDefault()
    }
  }

  handleWheel(event) {
    if (document.activeElement === this.element) {
      event.preventDefault()
    }
  }
}
