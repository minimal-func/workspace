ActiveAdmin.register WaitingListLog do
  permit_params :email, :status

  config.filters = false

  scope :all, default: true
  scope :pending
  scope :approved
  scope :declined

  index do
    selectable_column
    id_column
    column :email
    column "Status" do |log|
      status_tag log.status.titleize, class: log.status
    end
    column :reviewed_by
    column :created_at
    column "Invitation" do |log|
      if log.invitation
        link_to "Invite ##{log.invitation.id}", admin_invitation_path(log.invitation)
      else
        "—"
      end
    end
    actions defaults: false do |log|
      if log.pending?
        link_to "Approve", approve_admin_waiting_list_log_path(log), method: :post, class: "member_link"
      else
        link_to "Reject", reject_admin_waiting_list_log_path(log), method: :post, class: "member_link"
      end
    end
  end

  member_action :approve, method: :post do
    if resource.pending?
      invite = resource.approve!(reviewer: current_admin_user)
      redirect_to admin_invitation_path(invite), notice: "Approved. Invitation created."
    else
      redirect_to collection_path, alert: "Entry was already reviewed."
    end
  end

  member_action :reject, method: :post do
    if resource.pending?
      resource.reject!(reviewer: current_admin_user)
      redirect_to collection_path, notice: "Invitation request rejected."
    else
      redirect_to collection_path, alert: "Entry was already reviewed."
    end
  end
end