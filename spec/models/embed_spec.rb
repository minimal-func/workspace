require 'rails_helper'

RSpec.describe Embed, type: :model do
  describe "validations" do
    before do
      stub_request(:get, "http://localhost:8000").to_return(status: 200, body: "{}", headers: {})
    end

    it do
      is_expected.to validate_presence_of(:content)
    end
  end

  describe "#to_partial_path" do
    it "returns the correct partial path" do
      embed = Embed.new
      expect(embed.to_partial_path).to eq("embeds/embed")
    end
  end

  describe "#fetch_oembed_data" do
    let(:embed) { FactoryBot.build(:embed, content: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") }
    let(:oembed_response) do
      {
        height: 270,
        author_url: "https://www.youtube.com/user/RickAstleyVEVO",
        thumbnail_url: "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
        width: 480,
        author_name: "Rick Astley",
        thumbnail_height: 360,
        title: "Rick Astley - Never Gonna Give You Up (Video)",
        version: "1.0",
        provider_url: "https://www.youtube.com/",
        thumbnail_width: 480,
        type: "video",
        provider_name: "YouTube",
        html: "<iframe width=\"480\" height=\"270\" src=\"https://www.youtube.com/embed/dQw4w9WgXcQ\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>"
      }.to_json
    end

    before do
      stub_request(:get, "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=dQw4w9WgXcQ&format=json")
        .to_return(status: 200, body: oembed_response, headers: { 'Content-Type' => 'application/json' })
    end

    it "fetches and sets oembed data" do
      embed.valid? # Trigger after_validation callback
      
      expect(embed.height).to eq("270")
      expect(embed.author_url).to eq("https://www.youtube.com/user/RickAstleyVEVO")
      expect(embed.thumbnail_url).to eq("https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg")
      expect(embed.width).to eq("480")
      expect(embed.author_name).to eq("Rick Astley")
      expect(embed.thumbnail_height).to eq("360")
      expect(embed.title).to eq("Rick Astley - Never Gonna Give You Up (Video)")
      expect(embed.version).to eq("1.0")
      expect(embed.provider_url).to eq("https://www.youtube.com/")
      expect(embed.thumbnail_width).to eq("480")
      expect(embed.embed_type).to eq("video")
      expect(embed.provider_name).to eq("YouTube")
      expect(embed.html).to include("iframe")
    end
  end
end