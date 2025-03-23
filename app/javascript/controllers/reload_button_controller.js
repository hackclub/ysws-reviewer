import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]

  connect() {
    this.startRefreshing()
  }

  disconnect() {
    this.stopRefreshing()
  }

  startRefreshing() {
    this.refreshInterval = setInterval(() => {
      this.refreshFrame()
    }, 1000)
  }

  stopRefreshing() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval)
    }
  }

  refreshFrame() {
    const frame = document.getElementById("reload-button-frame")
    if (frame) {
      frame.setAttribute("src", "/ysws/reload")
      frame.reload()
    }
  }
} 