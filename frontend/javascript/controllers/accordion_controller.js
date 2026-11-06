import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("[data-accordion-trigger]").forEach((trigger) => {
      trigger.addEventListener("click", this.toggle.bind(this))
    })
  }

  toggle(event) {
    const item = event.currentTarget.closest(".Orbital-Accordion-Item")
    if (!item) return

    const content = item.querySelector(".Orbital-Accordion-Item-Content")
    if (!content) return

    const isOpen = content.dataset.state === "open"

    if (isOpen) {
      content.style.height = `${content.scrollHeight}px`
      content.offsetHeight // force reflow
      content.style.height = "0px"
      content.addEventListener(
        "transitionend",
        () => {
          content.dataset.state = "closed"
          content.style.height = ""
        },
        { once: true },
      )
    } else {
      content.dataset.state = "open"
      content.style.height = "0px"
      content.offsetHeight // force reflow
      content.style.height = `${content.scrollHeight}px`
      content.addEventListener(
        "transitionend",
        () => {
          content.style.height = ""
        },
        { once: true },
      )
    }
  }
}
