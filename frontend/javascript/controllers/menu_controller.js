import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="orbital-menu"
export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.currentIndex = -1
  }

  handleKeydown(event) {
    const items = this.getEnabledItems()
    if (items.length === 0) return

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.focusNext(items)
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPrevious(items)
        break
      case "Home":
        event.preventDefault()
        this.focusFirst(items)
        break
      case "End":
        event.preventDefault()
        this.focusLast(items)
        break
      case "ArrowRight":
        if (event.target.hasAttribute("aria-haspopup")) {
          event.preventDefault()
          this.activateItem(event.target)
        }
        break
      case "Enter":
      case " ": // Space
        event.preventDefault()
        this.activateItem(event.target)
        break
      case "Escape":
        event.preventDefault()
        this.closeMenu()
        break
      default:
        // Type-ahead: focus item starting with pressed key
        if (event.key.length === 1 && /^[a-z0-9]$/i.test(event.key)) {
          this.focusItemStartingWith(items, event.key)
        }
    }
  }

  getEnabledItems() {
    const items = []
    for (const child of this.element.children) {
      if (
        child.getAttribute("role") === "menuitem" &&
        !child.hasAttribute("data-disabled") &&
        child.getAttribute("aria-disabled") !== "true"
      ) {
        items.push(child)
      } else if (child.classList.contains("Orbital-Menu-Sub")) {
        const trigger = child.querySelector(":scope > .Orbital-Menu-Sub-Trigger")
        if (trigger) items.push(trigger)
      }
    }
    return items
  }

  focusNext(items) {
    const active = items.indexOf(document.activeElement)
    this.currentIndex = active < items.length - 1 ? active + 1 : 0
    this.updateFocus(items)
  }

  focusPrevious(items) {
    const active = items.indexOf(document.activeElement)
    this.currentIndex = active > 0 ? active - 1 : items.length - 1
    this.updateFocus(items)
  }

  focusFirst(items) {
    this.currentIndex = 0
    this.updateFocus(items)
  }

  focusLast(items) {
    this.currentIndex = items.length - 1
    this.updateFocus(items)
  }

  updateFocus(items = null) {
    const enabledItems = items || this.getEnabledItems()
    if (enabledItems.length === 0) return

    // Ensure currentIndex is valid
    this.currentIndex = Math.max(0, Math.min(this.currentIndex, enabledItems.length - 1))

    // Update tabindex for roving tabindex pattern
    enabledItems.forEach((item, index) => {
      if (index === this.currentIndex) {
        item.setAttribute("tabindex", "0")
        item.focus()
      } else {
        item.setAttribute("tabindex", "-1")
      }
    })
  }

  activateItem(item) {
    // Check if it's a submenu trigger
    if (item.hasAttribute("aria-haspopup")) {
      const subController = this.application.getControllerForElementAndIdentifier(
        item.closest('[data-controller*="orbital-menu-sub"]'),
        "orbital-menu-sub",
      )
      if (subController) {
        subController.toggle()
      }
    } else {
      // Activate the menu item (trigger click)
      item.click()
    }
  }

  focusItemStartingWith(items, key) {
    const lowerKey = key.toLowerCase()
    const startIndex = (this.currentIndex + 1) % items.length

    // Search from current position forward
    for (let i = 0; i < items.length; i++) {
      const index = (startIndex + i) % items.length
      const item = items[index]
      const text = item.textContent.trim().toLowerCase()

      if (text.startsWith(lowerKey)) {
        this.currentIndex = index
        this.updateFocus(items)
        return
      }
    }
  }

  closeMenu() {
    // If inside a popover, close it
    const popover = this.element.closest("[popover]")
    if (popover) {
      popover.hidePopover()
    }

    // If inside a submenu, close it
    const submenu = this.element.closest(".Orbital-Menu-Sub")
    if (submenu) {
      const subController = this.application.getControllerForElementAndIdentifier(submenu, "orbital-menu-sub")
      if (subController) {
        subController.close()
      }
    }
  }
}
