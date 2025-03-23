import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "preview", "expandButton", "collapseButton"]

  connect() {
    // Show preview by default, hide full content
    this.contentTarget.classList.add("hidden")
    this.collapseButtonTarget.classList.add("hidden")
  }

  expand() {
    this.previewTarget.classList.add("hidden")
    this.expandButtonTarget.classList.add("hidden")
    this.contentTarget.classList.remove("hidden")
    this.collapseButtonTarget.classList.remove("hidden")
  }

  collapse() {
    this.previewTarget.classList.remove("hidden")
    this.expandButtonTarget.classList.remove("hidden")
    this.contentTarget.classList.add("hidden")
    this.collapseButtonTarget.classList.add("hidden")
  }
} 