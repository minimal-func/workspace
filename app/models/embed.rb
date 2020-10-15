class Embed < ApplicationRecord
  include ActionText::Attachable

  validates :content, presence: true

  after_validation :fetch_oembed_data

  def to_partial_path
    "embeds/embed"
  end

  def fetch_oembed_data
    url =
      case content
      when /youtube/
        "https://www.youtube.com/oembed?url=#{content}&format=json"
      when /soundcloud/
        "https://soundcloud.com/oembed?url=#{content}&format=json"
      when /twitter/
        "https://publish.twitter.com/oembed?url=#{content}"
      end
    res = RestClient.get url
    json = JSON.parse(res.body, object_class: OpenStruct)
    self.height = json.height
    self.author_url = json.author_url
    self.thumbnail_url = json.thumbnail_url
    self.width = json.width
    self.author_name = json.author_name
    self.thumbnail_height = json.thumbnail_height
    self.title = json.title
    self.version = json.version
    self.provider_url = json.provider_url
    self.thumbnail_width = json.thumbnail_width
    self.embed_type = json.type
    self.provider_name = json.provider_name
    self.html = json.html
  end
end
