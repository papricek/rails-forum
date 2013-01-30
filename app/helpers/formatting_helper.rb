module FormattingHelper
  # override with desired markup formatter, e.g. textile or markdown
  def as_formatted_html(text)
    if formatter
      formatter.format(as_sanitized_text(text))
    else
      simple_format(h(text))
    end
  end

  def as_quoted_text(text)
    if formatter && formatter.respond_to?(:blockquote)
      formatter.blockquote(as_sanitized_text(text)).html_safe
    else
      "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
    end
  end

  def as_sanitized_text(text)
    if formatter.respond_to?(:sanitize)
      formatter.sanitize(text)
    else
      sanitize(text, :tags => %W(p), :attributes => [])
    end
  end

  private
  def formatter
    Formatters::Redcarpet
  end
end
