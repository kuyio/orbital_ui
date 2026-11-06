import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "input", "results", "item"]

  connect() {
    this.boundKeydown = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.boundKeydown)
    this.debounceTimer = null
    this.activeIndex = -1
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
    if (this.debounceTimer) clearTimeout(this.debounceTimer)
  }

  handleKeydown(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault()
      this.open()
    }
  }

  open() {
    this.dialogTarget.showModal()
    this.inputTarget.value = ""
    this.activeIndex = -1
    this.search("")

    requestAnimationFrame(() => this.inputTarget.focus())
  }

  close() {
    this.dialogTarget.close()
    this.activeIndex = -1
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  onInput() {
    const query = this.inputTarget.value
    if (this.debounceTimer) clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => this.search(query), 150)
  }

  async search(query) {
    const url = `/search?q=${encodeURIComponent(query)}`
    const response = await fetch(url, {
      headers: { Accept: "text/html", "X-Requested-With": "XMLHttpRequest" },
    })
    if (response.ok) {
      this.resultsTarget.innerHTML = await response.text()
      this.activeIndex = -1
      this.updateHighlight()
    }
  }

  onKeydown(event) {
    const items = this.itemTargets

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.activeIndex = Math.min(this.activeIndex + 1, items.length - 1)
        this.updateHighlight()
        break
      case "ArrowUp":
        event.preventDefault()
        this.activeIndex = Math.max(this.activeIndex - 1, 0)
        this.updateHighlight()
        break
      case "Enter":
        event.preventDefault()
        if (this.activeIndex >= 0 && items[this.activeIndex]) {
          this.navigateTo(items[this.activeIndex].href)
        }
        break
      case "Escape":
        event.preventDefault()
        this.close()
        break
    }
  }

  highlightItem(event) {
    const items = this.itemTargets
    const index = items.indexOf(event.currentTarget)
    if (index >= 0) {
      this.activeIndex = index
      this.updateHighlight()
    }
  }

  navigate(event) {
    event.preventDefault()
    this.navigateTo(event.currentTarget.href)
  }

  navigateTo(url) {
    this.close()
    window.Turbo.visit(url)
  }

  updateHighlight() {
    this.itemTargets.forEach((item, i) => {
      item.classList.toggle("active", i === this.activeIndex)
    })

    const active = this.itemTargets[this.activeIndex]
    if (active) active.scrollIntoView({ block: "nearest" })
  }
}
