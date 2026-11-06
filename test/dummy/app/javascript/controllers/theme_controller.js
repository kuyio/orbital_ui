import { Controller } from "@hotwired/stimulus"

const THEMES = {
  default: {},
  blue: {
    "--background": "#ffffff",
    "--foreground": "#020817",
    "--primary": "#2563eb",
    "--primary-foreground": "#f8fafc",
    "--secondary": "#f1f5f9",
    "--secondary-foreground": "#0f172a",
    "--destructive": "#ef4444",
    "--destructive-foreground": "#f8fafc",
    "--muted": "#f1f5f9",
    "--muted-foreground": "#64748b",
    "--accent": "#f1f5f9",
    "--accent-foreground": "#0f172a",
    "--card": "#ffffff",
    "--card-foreground": "#020817",
    "--popover": "#ffffff",
    "--popover-foreground": "#020817",
    "--border": "#e2e8f0",
    "--input": "#e2e8f0",
    "--ring": "#2563eb",
  },
  green: {
    "--background": "#ffffff",
    "--foreground": "#052e16",
    "--primary": "#16a34a",
    "--primary-foreground": "#f0fdf4",
    "--secondary": "#f0fdf4",
    "--secondary-foreground": "#14532d",
    "--destructive": "#ef4444",
    "--destructive-foreground": "#fafafa",
    "--muted": "#f0fdf4",
    "--muted-foreground": "#4b5563",
    "--accent": "#dcfce7",
    "--accent-foreground": "#14532d",
    "--card": "#ffffff",
    "--card-foreground": "#052e16",
    "--popover": "#ffffff",
    "--popover-foreground": "#052e16",
    "--border": "#d1d5db",
    "--input": "#d1d5db",
    "--ring": "#16a34a",
  },
  rose: {
    "--background": "#ffffff",
    "--foreground": "#1c1917",
    "--primary": "#e11d48",
    "--primary-foreground": "#fff1f2",
    "--secondary": "#fef2f2",
    "--secondary-foreground": "#1c1917",
    "--destructive": "#dc2626",
    "--destructive-foreground": "#fafafa",
    "--muted": "#f5f5f4",
    "--muted-foreground": "#78716c",
    "--accent": "#fef2f2",
    "--accent-foreground": "#1c1917",
    "--card": "#ffffff",
    "--card-foreground": "#1c1917",
    "--popover": "#ffffff",
    "--popover-foreground": "#1c1917",
    "--border": "#e7e5e4",
    "--input": "#e7e5e4",
    "--ring": "#e11d48",
  },
  violet: {
    "--background": "#ffffff",
    "--foreground": "#1e1b4b",
    "--primary": "#7c3aed",
    "--primary-foreground": "#f5f3ff",
    "--secondary": "#f5f3ff",
    "--secondary-foreground": "#1e1b4b",
    "--destructive": "#ef4444",
    "--destructive-foreground": "#fafafa",
    "--muted": "#f5f3ff",
    "--muted-foreground": "#6b7280",
    "--accent": "#ede9fe",
    "--accent-foreground": "#1e1b4b",
    "--card": "#ffffff",
    "--card-foreground": "#1e1b4b",
    "--popover": "#ffffff",
    "--popover-foreground": "#1e1b4b",
    "--border": "#e5e7eb",
    "--input": "#e5e7eb",
    "--ring": "#7c3aed",
  },
  orange: {
    "--background": "#ffffff",
    "--foreground": "#1a1a1a",
    "--primary": "#ea580c",
    "--primary-foreground": "#fff7ed",
    "--secondary": "#fff7ed",
    "--secondary-foreground": "#1a1a1a",
    "--destructive": "#dc2626",
    "--destructive-foreground": "#fafafa",
    "--muted": "#f5f5f4",
    "--muted-foreground": "#737373",
    "--accent": "#ffedd5",
    "--accent-foreground": "#1a1a1a",
    "--card": "#ffffff",
    "--card-foreground": "#1a1a1a",
    "--popover": "#ffffff",
    "--popover-foreground": "#1a1a1a",
    "--border": "#e5e5e5",
    "--input": "#e5e5e5",
    "--ring": "#ea580c",
  },
}

const DARK_THEMES = {
  default: {},
  blue: {
    "--background": "#020817",
    "--foreground": "#f8fafc",
    "--primary": "#3b82f6",
    "--primary-foreground": "#020817",
    "--secondary": "#1e293b",
    "--secondary-foreground": "#f8fafc",
    "--destructive": "#7f1d1d",
    "--destructive-foreground": "#f8fafc",
    "--muted": "#1e293b",
    "--muted-foreground": "#94a3b8",
    "--accent": "#1e293b",
    "--accent-foreground": "#f8fafc",
    "--card": "#020817",
    "--card-foreground": "#f8fafc",
    "--popover": "#020817",
    "--popover-foreground": "#f8fafc",
    "--border": "#1e293b",
    "--input": "#1e293b",
    "--ring": "#3b82f6",
  },
  green: {
    "--background": "#052e16",
    "--foreground": "#f0fdf4",
    "--primary": "#22c55e",
    "--primary-foreground": "#052e16",
    "--secondary": "#14532d",
    "--secondary-foreground": "#f0fdf4",
    "--destructive": "#7f1d1d",
    "--destructive-foreground": "#fafafa",
    "--muted": "#14532d",
    "--muted-foreground": "#86efac",
    "--accent": "#14532d",
    "--accent-foreground": "#f0fdf4",
    "--card": "#052e16",
    "--card-foreground": "#f0fdf4",
    "--popover": "#052e16",
    "--popover-foreground": "#f0fdf4",
    "--border": "#14532d",
    "--input": "#14532d",
    "--ring": "#22c55e",
  },
  rose: {
    "--background": "#1c1917",
    "--foreground": "#fafaf9",
    "--primary": "#fb7185",
    "--primary-foreground": "#1c1917",
    "--secondary": "#292524",
    "--secondary-foreground": "#fafaf9",
    "--destructive": "#7f1d1d",
    "--destructive-foreground": "#fafaf9",
    "--muted": "#292524",
    "--muted-foreground": "#a8a29e",
    "--accent": "#292524",
    "--accent-foreground": "#fafaf9",
    "--card": "#1c1917",
    "--card-foreground": "#fafaf9",
    "--popover": "#1c1917",
    "--popover-foreground": "#fafaf9",
    "--border": "#292524",
    "--input": "#292524",
    "--ring": "#fb7185",
  },
  violet: {
    "--background": "#1e1b4b",
    "--foreground": "#f5f3ff",
    "--primary": "#a78bfa",
    "--primary-foreground": "#1e1b4b",
    "--secondary": "#312e81",
    "--secondary-foreground": "#f5f3ff",
    "--destructive": "#7f1d1d",
    "--destructive-foreground": "#fafafa",
    "--muted": "#312e81",
    "--muted-foreground": "#c4b5fd",
    "--accent": "#312e81",
    "--accent-foreground": "#f5f3ff",
    "--card": "#1e1b4b",
    "--card-foreground": "#f5f3ff",
    "--popover": "#1e1b4b",
    "--popover-foreground": "#f5f3ff",
    "--border": "#312e81",
    "--input": "#312e81",
    "--ring": "#a78bfa",
  },
  orange: {
    "--background": "#1a1a1a",
    "--foreground": "#fafaf9",
    "--primary": "#fb923c",
    "--primary-foreground": "#1a1a1a",
    "--secondary": "#292524",
    "--secondary-foreground": "#fafaf9",
    "--destructive": "#7f1d1d",
    "--destructive-foreground": "#fafaf9",
    "--muted": "#292524",
    "--muted-foreground": "#a8a29e",
    "--accent": "#292524",
    "--accent-foreground": "#fafaf9",
    "--card": "#1a1a1a",
    "--card-foreground": "#fafaf9",
    "--popover": "#1a1a1a",
    "--popover-foreground": "#fafaf9",
    "--border": "#292524",
    "--input": "#292524",
    "--ring": "#fb923c",
  },
}

export default class extends Controller {
  static values = { current: { type: String, default: "default" } }

  connect() {
    const stored = localStorage.getItem("orbital-theme")
    if (stored && THEMES[stored]) {
      this.currentValue = stored
      this.apply(stored)
    }
    this.highlightActive()
  }

  select(event) {
    const theme = event.currentTarget.dataset.theme
    if (!theme) return
    this.currentValue = theme
    localStorage.setItem("orbital-theme", theme)
    this.apply(theme)
    this.highlightActive()
  }

  apply(name) {
    const isDark = document.documentElement.classList.contains("dark")
    const vars = isDark ? DARK_THEMES[name] || {} : THEMES[name] || {}
    const root = document.documentElement

    // Clear previous theme overrides
    Object.keys(THEMES.blue).forEach((prop) => {
      root.style.removeProperty(prop)
    })

    // Apply new theme
    Object.entries(vars).forEach(([prop, value]) => {
      root.style.setProperty(prop, value)
    })
  }

  highlightActive() {
    this.element.querySelectorAll("[data-theme]").forEach((el) => {
      el.classList.toggle("ring-2", el.dataset.theme === this.currentValue)
      el.classList.toggle("ring-primary", el.dataset.theme === this.currentValue)
      el.classList.toggle("ring-offset-2", el.dataset.theme === this.currentValue)
    })
  }
}
