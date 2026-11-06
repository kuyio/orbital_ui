import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const stored = localStorage.getItem("theme")
    if (stored === "dark" || (!stored && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
      document.documentElement.classList.add("dark")
    }
    this.updateIcon()
  }

  toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    localStorage.setItem("theme", isDark ? "dark" : "light")
    this.updateIcon()

    // Re-apply current color theme for the new mode
    const themeCtrl = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller~="theme"]'),
      "theme",
    )
    if (themeCtrl) themeCtrl.apply(themeCtrl.currentValue)
  }

  updateIcon() {
    const isDark = document.documentElement.classList.contains("dark")
    const sun = this.element.querySelector('[data-icon="sun"]')
    const moon = this.element.querySelector('[data-icon="moon"]')
    if (sun && moon) {
      sun.style.display = isDark ? "block" : "none"
      moon.style.display = isDark ? "none" : "block"
    }
  }
}
