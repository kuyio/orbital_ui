import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="orbital-select"
export default class extends Controller {
  static targets = ["input", "label"]
  static values = {
    selected: String,
  }

  connect() {
    // Initialize menu item states on connect
    this.updateMenuStates(this.selectedValue)
  }

  handleItemClick(event) {
    event.preventDefault()

    const menuItem = event.currentTarget

    // Don't select disabled items
    if (menuItem.dataset.disabled === "true" || menuItem.getAttribute("aria-disabled") === "true") {
      return
    }

    const value = menuItem.dataset.value
    const label = menuItem.dataset.label

    this.selectOption(value, label)
    this.closeDropdown()
  }

  selectOption(value, label) {
    // Update hidden input value
    if (this.hasInputTarget) {
      this.inputTarget.value = value
    }

    // Update trigger label
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = label
      this.labelTarget.classList.remove("Orbital-Select-Placeholder")
      this.labelTarget.classList.add("Orbital-Select-Label")
    }

    // Update stored value
    this.selectedValue = value

    // Update menu item selected states
    this.updateMenuStates(value)

    // Dispatch custom event for external listeners
    this.element.dispatchEvent(
      new CustomEvent("orbital:select:changed", {
        bubbles: true,
        detail: { value, label },
      }),
    )

    // Trigger native change event on hidden input for form integration
    if (this.hasInputTarget) {
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  updateMenuStates(selectedValue) {
    const menuItems = this.element.querySelectorAll(".Orbital-Menu-Item")

    menuItems.forEach((item) => {
      const itemValue = item.dataset.value
      const isSelected = itemValue === selectedValue

      // Update data attribute for CSS styling
      if (isSelected) {
        item.setAttribute("data-selected", "true")
        item.setAttribute("aria-selected", "true")
      } else {
        item.removeAttribute("data-selected")
        item.setAttribute("aria-selected", "false")
      }
    })
  }

  closeDropdown() {
    const container = this.element.querySelector('[data-controller="orbital-popover"]')
    if (!container) return

    const app = this.application
    const popoverCtrl = app.getControllerForElementAndIdentifier(container, "orbital-popover")
    if (popoverCtrl) {
      popoverCtrl.hide()
    }
  }

  // Lifecycle callback when selected value changes externally
  selectedValueChanged() {
    this.updateMenuStates(this.selectedValue)
  }
}
