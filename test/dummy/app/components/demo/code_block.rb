# frozen_string_literal: true

class Demo::CodeBlock < OrbitalUi::Component
  attribute :code, :string, default: ""
  attribute :collapsible, :boolean, default: false

  PREVIEW_LINES = 3

  def call
    if @collapsible
      lines = @code.split("\n")
      if lines.length > PREVIEW_LINES
        render_collapsible
      else
        content_tag(:div, render_code, class: "border-t")
      end
    else
      render_code
    end
  end

  private

  def render_collapsible
    content_tag(:div, class: "demo-code-collapsible border-t") do
      safe_join([
        content_tag(:div, render_code, class: "demo-code-wrapper"),
        content_tag(:button, "View Code",
          class: "demo-code-expand-btn",
          onclick: "var c=this.closest('.demo-code-collapsible');var ex=c.classList.toggle('expanded');" \
                   "this.textContent=ex?'Hide Code':'View Code'")
      ])
    end
  end

  def render_code
    lines = @code.split("\n")

    content_tag(:pre, class: "demo-code-block overflow-x-auto m-0") do
      content_tag(:code, class: "block") do
        safe_join(lines.each_with_index.map do |line, i|
          content_tag(:span, class: "demo-code-line") do
            safe_join([
              content_tag(:span, (i + 1).to_s.rjust(lines.length.digits.length), class: "demo-code-ln"),
              highlight_line(line)
            ])
          end
        end)
      end
    end
  end

  def highlight_line(line)
    escaped = ERB::Util.html_escape(line)

    tokens = []
    scanner = StringScanner.new(escaped)

    until scanner.eos?
      if scanner.scan(%r{(&lt;/?)([\w:.]+)})
        tokens << scanner[1]
        tokens << %(<span class="dc-tag">#{scanner[2]}</span>)
      elsif scanner.scan(/(\w+)(=&quot;)(.*?)(&quot;)/)
        tokens << %(<span class="dc-attr">#{scanner[1]}</span>)
        tokens << %(=&quot;<span class="dc-str">#{scanner[3]}</span>&quot;)
      elsif scanner.scan(/(&gt;)/)
        tokens << scanner[1]
      else
        tokens << ERB::Util.html_escape(scanner.getch)
      end
    end

    # Every token above is either escaped or a fixed span, so the result is safe.
    tokens.join.html_safe # rubocop:disable Rails/OutputSafety
  end
end
