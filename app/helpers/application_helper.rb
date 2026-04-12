module ApplicationHelper
  include Pagy::Frontend
  include EditorjsHelper

  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "https://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
  end

  def project_mascot_payload(section:, items_count:, completed_count: nil, empty_message:, project: nil, total_work_items: nil)
    completed_count = completed_count.nil? ? items_count : completed_count
    total_work_items ||= if project
                           project.tasks.count + project.posts.count + project.todos.count + project.saved_links.count + project.materials.count
                         else
                           items_count
                         end

    headline =
      if total_work_items.zero?
        "Sunny is ready to help this project take shape"
      elsif items_count.zero?
        "Sunny is watching the next #{section.to_s.singularize}"
      else
        project_name = project&.title || "your workspace"
        "Sunny can see momentum in #{project_name}"
      end

    message =
      if items_count.zero?
        empty_message
      elsif completed_count >= items_count && items_count.positive?
        "This area is fully handled right now. Sunny suggests opening a fresh #{section.to_s.singularize} only when it moves the project forward."
      else
        "There are #{total_work_items} tracked project items in motion. Keep building the #{section} layer so work, notes, files, and references stay connected."
      end

    focus =
      if total_work_items.zero?
        "Start with one task or note"
      elsif items_count.zero?
        "Next move: add your first #{section.to_s.singularize}"
      else
        "Next move: grow #{section} from #{items_count}"
      end

    {
      eyebrow: "Sunny's project desk",
      headline: headline,
      message: message,
      focus: focus
    }
  end
end
