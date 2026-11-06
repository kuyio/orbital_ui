import { autoPlacement, computePosition, flip, offset, shift } from "@floating-ui/dom"
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="orbital-popover"
export default class extends Controller {
  static values = {
    trigger: { type: String, default: "click" }, // "click" or "hover"
    position: { type: String, default: "auto" },
    showDelay: { type: Number, default: 0 },
    hideDelay: { type: Number, default: 100 },
  }

  static targets = ["trigger", "content"]

  connect() {
    this.boundShow = this.show.bind(this)
    this.boundHide = this.hide.bind(this)
    this.boundDelayedHide = this.delayedHide.bind(this)
    this.boundUpdatePosition = this.updatePosition.bind(this)
    this.boundOnNativeToggle = this.onNativeToggle.bind(this)
    this.hideTimeout = null

    // Set up trigger based on type
    if (this.triggerValue === "hover") {
      this.setupHoverTrigger()
    } else {
      this.setupClickTrigger()
    }

    // Sync data-state when the native popover API light-dismisses
    if (this.hasContentTarget) {
      this.contentTarget.addEventListener("toggle", this.boundOnNativeToggle)
    }
  }

  disconnect() {
    this.teardownTrigger()
    this.teardownPositioning()
    this.cancelShowTimeout()
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
    }
    if (this.hasContentTarget) {
      this.contentTarget.removeEventListener("toggle", this.boundOnNativeToggle)
    }
  }

  onNativeToggle(event) {
    if (event.newState === "closed" && this.element.getAttribute("data-state") === "open") {
      this.element.setAttribute("data-state", "closed")
      this.contentTarget.removeAttribute("data-positioned")
      this.teardownPositioning()
    }
  }

  // Actions
  async show() {
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
      this.hideTimeout = null
    }

    if (this.element.getAttribute("data-state") === "open") return

    if (this.hasContentTarget) {
      try {
        // Show popover invisibly first (CSS gate hides it until data-positioned is set)
        this.contentTarget.removeAttribute("data-positioned")
        this.contentTarget.showPopover()
        this.element.setAttribute("data-state", "open")

        // Now calculate position with the element visible and measurable
        const { x, y, placement } = await this.calculatePosition()
        this.contentTarget.style.left = `${x}px`
        this.contentTarget.style.top = `${y}px`
        this.contentTarget.dataset.placement = placement

        // Reveal at the correct position
        this.contentTarget.setAttribute("data-positioned", "true")

        this.setupPositioning()

        this.element.dispatchEvent(
          new CustomEvent("orbital:popover:shown", {
            bubbles: true,
            detail: { popover: this.contentTarget },
          }),
        )
      } catch (e) {
        // Popover API not supported, fallback gracefully
        console.warn("Popover API not supported:", e)
      }
    }
  }

  hide() {
    if (this.hasContentTarget) {
      try {
        this.contentTarget.hidePopover()
        this.element.setAttribute("data-state", "closed")

        // Clear positioned flag for next open
        this.contentTarget.removeAttribute("data-positioned")

        // Clean up positioning listeners
        this.teardownPositioning()

        // Dispatch custom event
        this.element.dispatchEvent(
          new CustomEvent("orbital:popover:hidden", {
            bubbles: true,
            detail: { popover: this.contentTarget },
          }),
        )
      } catch (e) {
        // Popover API not supported, fallback gracefully
        console.warn("Popover API not supported:", e)
      }
    }
  }

  delayedHide() {
    if (this.hideDelayValue === 0) {
      this.hide()
      return
    }
    this.hideTimeout = setTimeout(() => {
      this.hide()
    }, this.hideDelayValue)
  }

  async toggle() {
    if (this.hasContentTarget) {
      try {
        const isOpen = this.element.getAttribute("data-state") === "open"

        if (isOpen) {
          this.contentTarget.hidePopover()
          this.element.setAttribute("data-state", "closed")
          this.contentTarget.removeAttribute("data-positioned")
          this.teardownPositioning()
        } else {
          this.contentTarget.removeAttribute("data-positioned")
          this.contentTarget.showPopover()
          this.element.setAttribute("data-state", "open")

          const { x, y, placement } = await this.calculatePosition()
          this.contentTarget.style.left = `${x}px`
          this.contentTarget.style.top = `${y}px`
          this.contentTarget.dataset.placement = placement

          this.contentTarget.setAttribute("data-positioned", "true")
          this.setupPositioning()
        }
      } catch (e) {
        // Popover API not supported, fallback gracefully
        console.warn("Popover API not supported:", e)
      }
    }
  }

  static COMPASS_TO_PLACEMENT = {
    n: "top",
    ne: "top-end",
    e: "right",
    se: "bottom-end",
    s: "bottom",
    sw: "bottom-start",
    w: "left",
    nw: "top-start",
  }

  // Calculate position without applying it (for pre-positioning)
  async calculatePosition() {
    if (!this.hasTriggerTarget || !this.hasContentTarget) {
      return { x: 0, y: 0, placement: "bottom" }
    }

    const referenceEl = this.triggerTarget
    const floatingEl = this.contentTarget

    let middleware, placement

    if (this.positionValue === "auto") {
      middleware = [offset(8), autoPlacement(), shift({ padding: 8 })]
    } else {
      placement = this.constructor.COMPASS_TO_PLACEMENT[this.positionValue] || this.positionValue
      middleware = [offset(8), flip(), shift({ padding: 8 })]
    }

    try {
      const result = await computePosition(referenceEl, floatingEl, {
        placement,
        middleware,
      })

      return {
        x: result.x,
        y: result.y,
        placement: result.placement || placement || "bottom",
      }
    } catch (e) {
      console.warn("Failed to compute position:", e)
      return { x: 0, y: 0, placement: "bottom" }
    }
  }

  // Apply position and placement data attribute
  async updatePosition() {
    const { x, y, placement } = await this.calculatePosition()

    if (this.hasContentTarget) {
      Object.assign(this.contentTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      })
      this.contentTarget.dataset.placement = placement
    }
  }

  setupPositioning() {
    // Reposition on scroll and resize
    window.addEventListener("scroll", this.boundUpdatePosition, true)
    window.addEventListener("resize", this.boundUpdatePosition)
  }

  teardownPositioning() {
    window.removeEventListener("scroll", this.boundUpdatePosition, true)
    window.removeEventListener("resize", this.boundUpdatePosition)
  }

  // Lifecycle callback when position value changes
  positionValueChanged() {
    // Reposition if popover is currently open
    if (this.element.getAttribute("data-state") === "open") {
      this.updatePosition()
    }
  }

  // Private methods
  setupHoverTrigger() {
    this.boundCancelHide = () => {
      if (this.hideTimeout) {
        clearTimeout(this.hideTimeout)
        this.hideTimeout = null
      }
    }

    this.boundDelayedShow = () => {
      this.cancelShowTimeout()
      if (this.showDelayValue === 0) {
        this.show()
      } else {
        this.showTimeout = setTimeout(() => this.show(), this.showDelayValue)
      }
    }

    this.boundCancelShow = () => {
      this.cancelShowTimeout()
    }

    if (this.hasTriggerTarget) {
      this.triggerTarget.addEventListener("mouseenter", this.boundDelayedShow)
      this.triggerTarget.addEventListener("mouseleave", this.boundDelayedHide)
      this.triggerTarget.addEventListener("mouseleave", this.boundCancelShow)
    }

    if (this.hasContentTarget) {
      this.contentTarget.addEventListener("mouseenter", this.boundCancelHide)
      this.contentTarget.addEventListener("mouseleave", this.boundDelayedHide)
    }
  }

  cancelShowTimeout() {
    if (this.showTimeout) {
      clearTimeout(this.showTimeout)
      this.showTimeout = null
    }
  }

  setupClickTrigger() {
    if (this.hasTriggerTarget) {
      this.triggerTarget.addEventListener("click", this.handleClick.bind(this))
    }
  }

  teardownTrigger() {
    if (this.hasTriggerTarget) {
      this.triggerTarget.removeEventListener("mouseenter", this.boundDelayedShow)
      this.triggerTarget.removeEventListener("mouseleave", this.boundDelayedHide)
      this.triggerTarget.removeEventListener("mouseleave", this.boundCancelShow)
      this.triggerTarget.removeEventListener("click", this.handleClick.bind(this))
    }

    if (this.hasContentTarget) {
      this.contentTarget.removeEventListener("mouseenter", this.boundCancelHide)
      this.contentTarget.removeEventListener("mouseleave", this.boundDelayedHide)
    }
  }

  handleClick(event) {
    if (!this.hasContentTarget) return

    // Don't open if the trigger (or a button inside it) is disabled
    if (
      this.triggerTarget.closest('[data-disabled="true"]') ||
      this.triggerTarget.querySelector('[data-disabled="true"], [disabled], [aria-disabled="true"]')
    )
      return

    event.preventDefault()
    this.toggle()
  }

  async handleToggle(event) {
    const state = event.newState // "open" or "closed"
    this.element.setAttribute("data-state", state)

    // Update position when opened via native toggle event
    if (state === "open") {
      // Clear positioned flag during position calculation
      this.contentTarget.removeAttribute("data-positioned")

      // Position immediately (popover is already shown by native API)
      const { x, y, placement } = await this.calculatePosition()
      this.contentTarget.style.left = `${x}px`
      this.contentTarget.style.top = `${y}px`
      this.contentTarget.dataset.placement = placement

      // Mark as positioned to trigger CSS visibility
      this.contentTarget.setAttribute("data-positioned", "true")

      this.setupPositioning()

      // Focus first focusable item inside the popover (e.g. menu item)
      requestAnimationFrame(() => {
        const firstItem = this.contentTarget.querySelector('[role="menuitem"]:not([aria-disabled="true"])')
        if (firstItem) firstItem.focus()
      })
    } else {
      this.teardownPositioning()
    }

    // Dispatch custom event
    const eventName = state === "open" ? "orbital:popover:shown" : "orbital:popover:hidden"
    this.element.dispatchEvent(
      new CustomEvent(eventName, {
        bubbles: true,
        detail: { popover: this.contentTarget },
      }),
    )
  }
}
