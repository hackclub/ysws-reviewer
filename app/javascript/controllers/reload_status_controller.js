import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["liveStatus"]

  reload() {
    this.liveStatusTarget.textContent = "Queuing reload..."
    fetch("/ysws/reload", { 
      method: "POST", 
      headers: { 
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content 
      } 
    })
      .then(response => response.json())
      .then(data => {
        this.checkStatus(data.job_id)
      })
  }

  checkStatus(jobId) {
    const interval = setInterval(() => {
      fetch(`/ysws/reload_status?job_id=${jobId}`)
        .then(response => response.json())
        .then(data => {
          if (data.finished) {
            this.liveStatusTarget.textContent = `Reload completed in ${data.duration}s`
            clearInterval(interval)
            setTimeout(() => location.reload(), 2000)
          } else {
            this.liveStatusTarget.textContent = `Reload running: ${data.running_time}s elapsed`
          }
        })
    }, 2000)
  }
} 