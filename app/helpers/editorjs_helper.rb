module EditorjsHelper
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
    when "header"   then render_header_block(block)
    when "paragraph" then render_paragraph_block(block)
    when "list"     then render_list_block(block)
    when "checklist" then render_checklist_block(block)
    when "quote"    then render_quote_block(block)
    when "code"     then render_code_block(block)
    when "image"    then render_image_block(block)
    when "table"    then render_table_block(block)
    when "delimiter" then content_tag(:hr)
    when "warning"  then render_warning_block(block)
    when "raw"      then block["data"]["html"].html_safe
    when "embed"    then render_embed_block(block)
    else ""
    end
  end

  def render_header_block(block)
    content_tag("h#{block['data']['level']}", block["data"]["text"].to_s.html_safe)
  end

  def render_paragraph_block(block)
    content_tag(:p, block["data"]["text"].to_s.html_safe)
  end

  def render_list_block(block)
    list_type = block["data"]["style"] == "ordered" ? :ol : :ul
    content_tag(list_type) { render_list_items(block["data"]["items"]) }
  end

  def render_checklist_block(block)
    content_tag(:div, class: 'editorjs-checklist') do
      block["data"]["items"].map do |item|
        content_tag(:div, class: "checklist-item #{item['checked'] ? 'checklist-item--checked' : ''}") do
          content_tag(:span, class: 'checklist-item__checkbox') { item["checked"] ? "✓" : "" } +
            " " + content_tag(:span, item["text"].to_s.html_safe, class: 'checklist-item__text')
        end
      end.join.html_safe
    end
  end

  def render_quote_block(block)
    content_tag(:figure) do
      content_tag(:blockquote, block["data"]["text"].to_s.html_safe) +
        content_tag(:figcaption, block["data"]["caption"].to_s.html_safe)
    end
  end

  def render_code_block(block)
    content_tag(:pre) { content_tag(:code, block["data"]["code"]) }
  end

  def render_image_block(block)
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
  end

  def render_table_block(block)
    content_tag(:table, class: 'table') do
      content_tag(:tbody) do
        block["data"]["content"].map do |row|
          content_tag(:tr) do
            row.map { |cell| content_tag(:td, cell.to_s.html_safe) }.join.html_safe
          end
        end.join.html_safe
      end
    end
  end

  def render_warning_block(block)
    content_tag(:div, class: 'alert alert-warning') do
      content_tag(:strong, block["data"]["title"]) + tag(:br) + block["data"]["message"]
    end
  end

  def render_embed_block(block)
    service = block["data"]["service"]
    source = block["data"]["source"]
    embed = block["data"]["embed"]
    width = block["data"]["width"]
    height = block["data"]["height"]
    caption = block["data"]["caption"]

    content_tag(:figure, class: "embed-wrapper") do
      content_tag(:div, class: "embed-container", style: "position: relative; padding-bottom: #{(height.to_f / width.to_f * 100).round(2)}%; height: 0; overflow: hidden;") do
        content_tag(:iframe, "", src: embed, frameborder: 0, allowfullscreen: true, style: "position: absolute; top: 0; left: 0; width: 100%; height: 100%;")
      end +
        (caption.present? ? content_tag(:figcaption, caption.to_s.html_safe) : "")
    end
  end
end
