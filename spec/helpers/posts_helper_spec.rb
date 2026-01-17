require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe "#render_editorjs_blocks" do
    it "renders a nested list correctly" do
      json_data = {
        "blocks" => [
          {
            "id" => "123",
            "type" => "list",
            "data" => {
              "style" => "unordered",
              "items" => [
                {
                  "content" => "Item 1",
                  "items" => [
                    {
                      "content" => "Nested Item 1.1",
                      "items" => []
                    }
                  ]
                }
              ]
            }
          }
        ]
      }

      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("Item 1")
      expect(result).to include("Nested Item 1.1")
      expect(result).to include("<ul>")
      expect(result).to include("<li>")
    end

    it "renders a simple list correctly (backward compatibility)" do
      json_data = {
        "blocks" => [
          {
            "id" => "123",
            "type" => "list",
            "data" => {
              "style" => "unordered",
              "items" => ["Simple Item"]
            }
          }
        ]
      }

      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("Simple Item")
    end

    it "renders a checklist correctly" do
      json_data = {
        "blocks" => [
          {
            "id" => "chk1",
            "type" => "checklist",
            "data" => {
              "items" => [
                { "text" => "Task 1", "checked" => true },
                { "text" => "Task 2", "checked" => false }
              ]
            }
          }
        ]
      }

      result = helper.render_editorjs_blocks(json_data)
      expect(result).to include("Task 1")
      expect(result).to include("Task 2")
      expect(result).to include('checklist-item--checked')
      expect(result).to include('checklist-item__checkbox')
      expect(result).to include('✓')
    end
  end
end
