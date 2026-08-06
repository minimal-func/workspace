module ApplicationHelper
  include Pagy::Frontend
  include EditorjsHelper

  def user_avatar_source(user)
    return "avatar-round-1.png" unless user&.avatar&.attached?
    user.avatar
  end

  def mascot_action_for(section)
    MascotPayload.action_for(section)
  end

  def project_mascot_payload(section:, items_count:, completed_count: nil, empty_message:, project: nil, total_work_items: nil)
    MascotPayload.project(
      section: section,
      items_count: items_count,
      completed_count: completed_count,
      empty_message: empty_message,
      project: project,
      total_work_items: total_work_items
    )
  end

  def feature_link(feature, path)
    if feature_unlocked?(feature)
      link_to User.feature_name(feature), path
    else
      content_tag(:span, class: 'text-muted locked', title: "Reach Level #{User.feature_unlock_level(feature)} to unlock #{User.feature_name(feature)}") do
        "#{User.feature_name(feature)} (Level #{User.feature_unlock_level(feature)})"
      end
    end
  end

  alias project_feature_link feature_link

  def journal_mascot_payload(section:, items_count:)
    MascotPayload.journal(section: section, items_count: items_count)
  end
end
