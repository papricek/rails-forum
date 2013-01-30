module FormattingHelper
  # override with desired markup formatter, e.g. textile or markdown
  def as_formatted_html(text)
    text = h(text)
    text = text.gsub(/\[code\]/, '<pre><code>')
    text = text.gsub(/\[\/code\]/, '</code></pre>')
    simple_format(text.html_safe)
  end

  def as_quoted_text(text)
    "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
  end

  def as_sanitized_text(text)
    sanitize(text, :tags => %W(p), :attributes => [])
  end
end
