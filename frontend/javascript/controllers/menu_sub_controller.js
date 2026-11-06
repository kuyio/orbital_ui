import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="orbital-menu-sub"
export default class extends Controller {
  static targets = ["trigger", "content"]

  connect() {
    this._onClickOutside = (e) => {
      if (this.element.getAttribute("data-state") === "open" && !this.element.contains(e.target)) {
        this.close(false)
      }
    }
  }

  disconnect() {
    document.removeEventListener("click", this._onClickOutside)
  }

  toggle() {
    const isOpen = this.element.getAttribute("data-state") === "open"
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.element.setAttribute("data-state", "open")
    this.triggerTarget.setAttribute("aria-expanded", "true")
    document.addEventListener("click", this._onClickOutside)

    requestAnimationFrame(() => {
      const firstItem = this.contentTarget.querySelector('[role="menuitem"]')
      if (firstItem) firstItem.focus()
    })
  }

  close(refocus = true) {
    this.element.setAttribute("data-state", "closed")
    this.triggerTarget.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this._onClickOutside)

    if (refocus) this.triggerTarget.focus()
  }

  handleKeydown(event) {
    const items = [...this.contentTarget.querySelectorAll('[role="menuitem"]:not([aria-disabled="true"])')]
    if (!items.length) return

    const current = items.indexOf(document.activeElement)

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        event.stopPropagation()
        items[current < items.length - 1 ? current + 1 : 0].focus()
        break
      case "ArrowUp":
        event.preventDefault()
        event.stopPropagation()
        items[current > 0 ? current - 1 : items.length - 1].focus()
        break
      case "ArrowLeft":
      case "Escape":
        event.preventDefault()
        event.stopPropagation()
        this.close()
        break
      case "Enter":
      case " ":
        event.stopPropagation()
        break
    }
  }
}
