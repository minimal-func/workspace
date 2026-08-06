module Taggable
  extend ActiveSupport::Concern

  included do
    attribute :tags, :string, array: true, default: []
  end

  def tag_list
    tags || []
  end

  def tag_list=(value)
    self.tags = value.to_s.split(",").map(&:strip).reject(&:blank?)
  end
end
