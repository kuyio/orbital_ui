# frozen_string_literal: true

class Demo::Example < OrbitalUi::Component
  attribute :source, :string, default: ""
  attribute :context, :any, default: -> { {} }
  attribute :align, :symbol, default: :center, only: [:center, :start]
  attribute :resizable, :boolean, default: false

  def before_render
    # rubocop:disable Rails/RenderInline -- Docs examples render their own ORB source, which is the point of this component.
    @compiled = render(inline: @source, type: :orb, locals: @context).to_str
    # rubocop:enable Rails/RenderInline
    @clean_source = beautify(@source)
  end

  def call
    content_tag(:div, **html_attributes) do
      safe_join([
        preview_area,
        render(Demo::CodeBlock.new(code: @clean_source, collapsible: true))
      ])
    end
  end

  def preview_area
    # rubocop:disable Rails/OutputSafety -- @compiled is the rendered output of source written in this app's views.
    preview = content_tag(:div, @compiled.html_safe, class: class_names(
      "demo-preview flex justify-center p-8",
      @align == :center ? "items-center" : "pt-12",
      @resizable ? "demo-preview-resizable" : nil
    ))
    # rubocop:enable Rails/OutputSafety

    if @resizable
      content_tag(:div, preview, class: "demo-preview-resizable-wrapper")
    else
      preview
    end
  end

  private

  def default_attributes
    super.merge(class: "border rounded-lg bg-card overflow-hidden")
  end

  def beautify(src)
    lines = src.lines
    lines = lines.drop_while { |l| l.strip.empty? }
    lines = lines.reverse.drop_while { |l| l.strip.empty? }.reverse
    return "" if lines.empty?

    indent = lines.reject { |l| l.strip.empty? }.map { |l| l.index(/\S/) || 0 }.min
    lines.map { |l| l[indent..] || "\n" }.join
  end
end
