import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "empty"]

  filter(event) {
    const query = event.target.value.trim().toLowerCase()
    let visible = 0
    this.rowTargets.forEach((row) => {
      const matches = row.textContent.toLowerCase().includes(query)
      row.hidden = !matches
      if (matches) visible += 1
    })
    this.emptyTarget.hidden = visible > 0
  }
}
