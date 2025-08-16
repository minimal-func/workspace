class Material < ApplicationRecord
  validates :title, presence: true
  validate :file_attachment_for_non_folders

  has_one_attached :file, dependent: :destroy

  belongs_to :project
  belongs_to :parent, class_name: 'Material', optional: true
  has_many :children, class_name: 'Material', foreign_key: 'parent_id', dependent: :destroy

  scope :folders, -> { where(is_folder: true) }
  scope :files, -> { where(is_folder: false) }
  scope :root_items, -> { where(parent_id: nil) }

  def folder?
    is_folder
  end

  def file?
    !is_folder
  end

  def path
    if parent
      "#{parent.path}/#{title}"
    else
      title
    end
  end

  def ancestors
    return [] unless parent
    parent.ancestors + [parent]
  end

  def descendants
    return [] unless folder?
    children.flat_map { |child| [child] + child.descendants }
  end

  private

  def file_attachment_for_non_folders
    if folder? && file.attached?
      errors.add(:file, 'cannot be attached to folders')
    end
  end
end
