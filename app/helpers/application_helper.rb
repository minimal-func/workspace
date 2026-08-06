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

  def project_feature_link(feature, path)
    if project_feature_unlocked?(feature)
      link_to User.project_feature_name(feature), path
    else
      content_tag(:span, class: 'text-muted locked', title: "Reach Level #{User.project_feature_unlock_level(feature)} to unlock #{User.project_feature_name(feature)}") do
        "#{User.project_feature_name(feature)} (Level #{User.project_feature_unlock_level(feature)})"
      end
    end
  end

  def journal_mascot_payload(section:, items_count:)
    MascotPayload.journal(section: section, items_count: items_count)
  end
end
