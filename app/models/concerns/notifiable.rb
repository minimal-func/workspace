module Notifiable
  extend ActiveSupport::Concern

  included do
    after_create_commit :creation_notification
    after_update_commit :update_notification
  end

  private

  def creation_notification
    generation_notification('created')
  end

  def update_notification
    generation_notification('updated')
  end

  def generation_notification(action)
    user = notification_recipient
    return unless user

    message = if is_a?(Point)
                "You've earned #{value} points for #{self.action.humanize.downcase}!"
              else
                "#{self.class.model_name.human} was #{action}: #{notification_record_name}"
              end

    Notification.create!(
      user:,
      notifiable: self,
      message:
    )
  end

  def notification_recipient
    return user if respond_to?(:user)
    return project.user if respond_to?(:project) && project.respond_to?(:user)

    nil
  end

  def notification_record_name
    if respond_to?(:title) && title.present?
      title
    elsif respond_to?(:name) && name.present?
      name
    elsif respond_to?(:value) && value.present?
      "Value: #{value}"
    elsif respond_to?(:id)
      "Record ##{id}"
    else
      ''
    end
  end
end
