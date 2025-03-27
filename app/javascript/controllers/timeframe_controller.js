import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customRange", "dateInput"]

  connect() {
    this.toggle()
  }

  toggle() {
    const select = this.element.querySelector('select')
    const isCustom = select.value === 'custom'
    this.customRangeTarget.classList.toggle('hidden', !isCustom)
    
    // Toggle required attribute on date inputs
    this.dateInputTargets.forEach(input => {
      input.required = isCustom
    })
  }
} 