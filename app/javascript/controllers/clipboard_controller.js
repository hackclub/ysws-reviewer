import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  static values = {
    url: String,
    successText: { type: String, default: "Copied!" },
    defaultText: { type: String, default: "Copy Airtable URL" }
  }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.urlValue)
      
      // Update button text temporarily
      const button = this.buttonTarget
      const originalText = button.innerHTML
      button.innerHTML = this.successTextValue
      
      // Reset button text after 2 seconds
      setTimeout(() => {
        button.innerHTML = originalText
      }, 2000)
    } catch (err) {
      console.error('Failed to copy text: ', err)
    }
  }
} 