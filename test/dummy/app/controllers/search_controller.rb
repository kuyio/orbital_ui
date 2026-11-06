# frozen_string_literal: true

class SearchController < ApplicationController
  ENTRIES = [
    { title: "Accordion", description: "Collapsible content sections", url: "/components/accordion",
      category: "Components" },
    { title: "Alert", description: "Feedback messages for user actions", url: "/components/alert",
      category: "Components" },
    { title: "Avatar", description: "User profile image with fallback initials", url: "/components/avatar",
      category: "Components" },
    { title: "Badge", description: "Small status label or tag", url: "/components/badge", category: "Components" },
    { title: "Button", description: "Interactive action trigger", url: "/components/button", category: "Components" },
    { title: "Button Group", description: "Grouped row of related buttons", url: "/components/button-group",
      category: "Components" },
    { title: "Card", description: "Structured content container with header, body, footer", url: "/components/card",
      category: "Components" },
    { title: "CheckBox", description: "Binary toggle for form input", url: "/components/checkbox",
      category: "Components" },
    { title: "Dialog", description: "Modal overlay for focused tasks", url: "/components/dialog",
      category: "Components" },
    { title: "Dropdown", description: "Button with floating menu panel", url: "/components/dropdown",
      category: "Components" },
    { title: "Expander", description: "Flexible space that pushes siblings apart", url: "/components/expander",
      category: "Components" },
    { title: "Grid", description: "CSS Grid container with column and span control", url: "/components/grid",
      category: "Components" },
    { title: "Heading", description: "Title text with semantic heading levels", url: "/components/heading",
      category: "Components" },
    { title: "Icon", description: "SVG icon from the Lucide and Font Awesome sets", url: "/components/icon",
      category: "Components" },
    { title: "Image", description: "Responsive image with asset pipeline integration", url: "/components/image",
      category: "Components" },
    { title: "InlineStack", description: "Horizontal flex container with spacing and alignment",
      url: "/components/inline-stack", category: "Components" },
    { title: "Kbd", description: "Keyboard shortcut indicator", url: "/components/kbd", category: "Components" },
    { title: "Menu", description: "Vertical list of actions and navigation items", url: "/components/menu",
      category: "Components" },
    { title: "Navigation Menu", description: "Top-level site navigation bar", url: "/components/navigation-menu",
      category: "Components" },
    { title: "Popcard", description: "Rich hover preview card", url: "/components/popcard", category: "Components" },
    { title: "Popover", description: "Floating panel anchored to a trigger", url: "/components/popover",
      category: "Components" },
    { title: "Select", description: "Dropdown select field for form input", url: "/components/select",
      category: "Components" },
    { title: "Separator", description: "Visual divider between sections", url: "/components/separator",
      category: "Components" },
    { title: "Spinner", description: "Animated loading indicator", url: "/components/spinner", category: "Components" },
    { title: "Text", description: "Body text with size, weight, and tone", url: "/components/text",
      category: "Components" },
    { title: "TextField", description: "Text input with labels, icons, and validation", url: "/components/text-field",
      category: "Components" },
    { title: "Tooltip", description: "Small hover label for elements", url: "/components/tooltip",
      category: "Components" },
    { title: "Typography", description: "Semantic text elements with preset styles", url: "/components/typography",
      category: "Components" },
    { title: "Blocks", description: "Composed UI patterns from Orbital components", url: "/blocks", category: "Pages" },
    { title: "Themes", description: "Color theme presets and customization", url: "/themes", category: "Pages" },
    { title: "Colors", description: "Semantic color palette reference", url: "/colors", category: "Pages" }
  ].freeze

  def index
    query = params[:q].to_s.strip.downcase
    @results = if query.blank?
                 ENTRIES
               else
                 ENTRIES.select { |e| e[:title].downcase.include?(query) || e[:description].downcase.include?(query) }
               end
  end
end
