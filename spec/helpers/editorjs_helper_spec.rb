require 'rails_helper'

RSpec.describe EditorjsHelper, type: :helper do

  describe "#render_editorjs_blocks" do
    it "returns empty string when json_data is nil" do
      expect(helper.render_editorjs_blocks(nil)).to eq("")
    end

    it "returns empty string when json_data is blank" do
      expect(helper.render_editorjs_blocks({})).to eq("")
    end

    it "renders a paragraph block" do
      json_data = {
        "blocks" => [
          { "type" => "paragraph", "data" => { "text" => "Hello world" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<p>Hello world</p>")
    end

    it "renders a header block" do
      json_data = {
        "blocks" => [
          { "type" => "header", "data" => { "level" => 2, "text" => "My Header" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<h2>My Header</h2>")
    end

    it "renders a quote block" do
      json_data = {
        "blocks" => [
          { "type" => "quote", "data" => { "text" => "Quote text", "caption" => "Author" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<blockquote>Quote text</blockquote>")
      expect(result).to include("<figcaption>Author</figcaption>")
    end

    it "renders a code block" do
      json_data = {
        "blocks" => [
          { "type" => "code", "data" => { "code" => "puts 'hello'" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<code>puts &#39;hello&#39;</code>")
    end

    it "renders a delimiter block" do
      json_data = {
        "blocks" => [
          { "type" => "delimiter", "data" => {} }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<hr>")
    end

    it "renders a warning block" do
      json_data = {
        "blocks" => [
          { "type" => "warning", "data" => { "title" => "Warning", "message" => "Be careful" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("alert alert-warning")
      expect(result).to include("Warning")
      expect(result).to include("Be careful")
    end

    it "renders a raw HTML block" do
      json_data = {
        "blocks" => [
          { "type" => "raw", "data" => { "html" => "<div>Raw HTML</div>" } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<div>Raw HTML</div>")
    end

    it "renders a table block" do
      json_data = {
        "blocks" => [
          { "type" => "table", "data" => { "content" => [["A", "B"], ["C", "D"]] } }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("<table")
      expect(result).to include("<td>A</td>")
      expect(result).to include("<td>D</td>")
    end

    it "returns empty string for unknown block type" do
      json_data = {
        "blocks" => [
          { "type" => "unknown", "data" => {} }
        ]
      }
      result = helper.render_editorjs_blocks(json_data)
      expect(result).to eq("")
    end

    it "handles JSON string input" do
      json_string = '{"blocks":[{"type":"paragraph","data":{"text":"Parsed from string"}}]}'
      result = helper.render_editorjs_blocks(json_string)
      expect(result).to include("<p>Parsed from string</p>")
    end

    it "handles malformed JSON gracefully" do
      result = helper.render_editorjs_blocks("not json")
      expect(result).to eq("")
    end
  end
end
