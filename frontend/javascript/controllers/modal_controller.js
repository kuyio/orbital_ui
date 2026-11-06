import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    open: { type: Boolean, default: false },
    dismissible: { type: Boolean, default: true },
  }

  static targets = ["panel"]

  connect() {
    this._handleKeydown = this.handleKeydown.bind(this)
    this._previouslyFocused = null
    this._originalStyles = null
    this._scrollY = 0

    if (this.openValue) {
      requestAnimationFrame(() => this.show())
    }
  }

  disconnect() {
    this._restoreScrollLock()
    document.removeEventListener("keydown", this._handleKeydown)
  }

  show() {
    if (this.element.dataset.state === "open") return

    this._previouslyFocused = document.activeElement
    this.element.setAttribute("data-state", "open")
    this._applyScrollLock()
    document.addEventListener("keydown", this._handleKeydown)

    requestAnimationFrame(() => this._focusFirst())

    this.element.dispatchEvent(new CustomEvent("orbital:modal:open", { bubbles: true }))
  }

  close() {
    if (this.element.dataset.state === "closed") return

    this.element.setAttribute("data-state", "closed")
    this._restoreScrollLock()
    document.removeEventListener("keydown", this._handleKeydown)

    if (this._previouslyFocused && typeof this._previouslyFocused.focus === "function") {
      this._previouslyFocused.focus()
      this._previouslyFocused = null
    }

    this.element.dispatchEvent(new CustomEvent("orbital:modal:close", { bubbles: true }))

    this._clearTurboFrame()
  }

  backdropClick(event) {
    if (event.target === event.currentTarget && this.dismissibleValue) {
      this.close()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      event.stopPropagation()
      if (this.dismissibleValue) {
        this.close()
      }
      return
    }

    if (event.key === "Tab") {
      this._trapFocus(event)
    }
  }

  _applyScrollLock() {
    if (document.body.dataset.orbitalScrollLocked) return

    this._scrollY = window.scrollY
    const htmlStyle = getComputedStyle(document.documentElement)
    const hasStableGutter = htmlStyle.scrollbarGutter?.includes("stable")

    this._originalStyles = {
      overflow: document.body.style.overflow,
      paddingRight: document.body.style.paddingRight,
    }
    document.body.style.overflow = "hidden"
    if (!hasStableGutter) {
      const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth
      if (scrollbarWidth > 0) {
        document.body.style.paddingRight = `${scrollbarWidth}px`
      }
    }
    document.body.dataset.orbitalScrollLocked = "true"
  }

  _restoreScrollLock() {
    if (!this._originalStyles) return

    document.body.style.overflow = this._originalStyles.overflow
    document.body.style.paddingRight = this._originalStyles.paddingRight
    delete document.body.dataset.orbitalScrollLocked
    this._originalStyles = null
  }

  _focusableElements() {
    if (!this.hasPanelTarget) return []
    const selector = [
      "a[href]",
      "button:not([disabled])",
      "input:not([disabled]):not([type='hidden'])",
      "select:not([disabled])",
      "textarea:not([disabled])",
      "[tabindex]:not([tabindex='-1'])",
      "[contenteditable]",
    ].join(", ")
    return [...this.panelTarget.querySelectorAll(selector)].filter(
      (el) => !el.closest("[hidden]") && !el.closest("[aria-hidden='true']"),
    )
  }

  _focusFirst() {
    const focusable = this._focusableElements()
    if (focusable.length > 0) {
      focusable[0].focus({ preventScroll: true })
    } else if (this.hasPanelTarget) {
      this.panelTarget.setAttribute("tabindex", "-1")
      this.panelTarget.focus({ preventScroll: true })
    }
  }

  _trapFocus(event) {
    const focusable = this._focusableElements()
    if (focusable.length === 0) return

    const first = focusable[0]
    const last = focusable[focusable.length - 1]

    if (event.shiftKey) {
      if (document.activeElement === first) {
        event.preventDefault()
        last.focus({ preventScroll: true })
      }
    } else {
      if (document.activeElement === last) {
        event.preventDefault()
        first.focus({ preventScroll: true })
      }
    }
  }

  _clearTurboFrame() {
    const frame = this.element.closest("turbo-frame")
    if (frame) {
      frame.innerHTML = ""
      frame.removeAttribute("src")
      frame.removeAttribute("complete")
    }
  }
}
