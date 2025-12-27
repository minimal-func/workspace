module PostsHelper
  def render_editorjs_blocks(json_data)
    return "" if json_data.blank?

    blocks = json_data.is_a?(String) ? JSON.parse(json_data)["blocks"] : json_data["blocks"]
    return "" if blocks.blank?

    blocks.map do |block|
      render_block(block)
    end.join.html_safe
  rescue JSON::ParserError
    ""
  end

  private

  def render_list_items(items)
    items.map do |item|
      if item.is_a?(Hash)
        content_tag(:li) do
          content = item["content"].to_s.html_safe
          if item["items"].present?
            content += content_tag(:ul) do
              render_list_items(item["items"])
            end
          end
          content
        end
      else
        content_tag(:li, item.to_s.html_safe)
      end
    end.join.html_safe
  end

  def render_block(block)
    case block["type"]
    when "header"
      content_tag("h#{block['data']['level']}", block["data"]["text"].to_s.html_safe)
    when "paragraph"
      content_tag(:p, block["data"]["text"].to_s.html_safe)
    when "list"
      list_type = block["data"]["style"] == "ordered" ? :ol : :ul
      content_tag(list_type) do
        render_list_items(block["data"]["items"])
      end
    when "checklist"
      content_tag(:div, class: 'editorjs-checklist') do
        block["data"]["items"].map do |item|
          content_tag(:div, class: "checklist-item #{item['checked'] ? 'checklist-item--checked' : ''}") do
            content_tag(:span, class: 'checklist-item__checkbox') do
              item["checked"] ? "✓" : ""
            end + " " + content_tag(:span, item["text"].to_s.html_safe, class: 'checklist-item__text')
          end
        end.join.html_safe
      end
    when "quote"
      content_tag(:figure) do
        content_tag(:blockquote, block["data"]["text"].to_s.html_safe) +
          content_tag(:figcaption, block["data"]["caption"].to_s.html_safe)
      end
    when "code"
      content_tag(:pre) do
        content_tag(:code, block["data"]["code"])
      end
    when "image"
      url = block["data"]["file"]["url"]
      caption = block["data"]["caption"]
      classes = []
      classes << "stretched" if block["data"]["stretched"]
      classes << "with-background" if block["data"]["withBackground"]
      classes << "with-border" if block["data"]["withBorder"]
      
      content_tag(:figure, class: classes.join(" ")) do
        image_tag(url, class: 'img-fluid') +
          (caption.present? ? content_tag(:figcaption, caption.to_s.html_safe) : "")
      end
    when "table"
      content_tag(:table, class: 'table') do
        content_tag(:tbody) do
          block["data"]["content"].map do |row|
            content_tag(:tr) do
              row.map { |cell| content_tag(:td, cell.to_s.html_safe) }.join.html_safe
            end
          end.join.html_safe
        end
      end
    when "delimiter"
      content_tag(:hr)
    when "warning"
      content_tag(:div, class: 'alert alert-warning') do
        content_tag(:strong, block["data"]["title"]) + tag(:br) + block["data"]["message"]
      end
    when "raw"
      block["data"]["html"].html_safe
    else
      ""
    end
  end
end
