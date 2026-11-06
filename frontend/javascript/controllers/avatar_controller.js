import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "fallback"]

  imageError() {
    if (this.hasImageTarget) this.imageTarget.style.display = "none"
    if (this.hasFallbackTarget) this.fallbackTarget.style.display = "flex"
  }
}
