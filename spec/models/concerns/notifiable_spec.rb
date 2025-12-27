require 'rails_helper'

RSpec.describe Notifiable, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, user: user) }

  describe "Project notifications" do
    it "creates a notification when a project is created" do
      expect {
        FactoryBot.create(:project, user: user, title: "New Project")
      }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.message).to eq("Project was created: New Project")
      expect(notification.user).to eq(user)
    end

    it "creates a notification when a project is updated" do
      project = FactoryBot.create(:project, user: user, title: "Old Title")
      expect {
        project.update(title: "New Title")
      }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.message).to eq("Project was updated: New Title")
    end
  end

  describe "Post notifications" do
    it "creates a notification when a post is created" do
      project # trigger creation
      expect {
        FactoryBot.create(:post, project: project, title: "New Post")
      }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.message).to eq("Post was created: New Post")
      expect(notification.user).to eq(user)
    end
  end

  describe "Mood notifications" do
    it "creates a notification when a mood is created" do
      expect {
        FactoryBot.create(:mood, user: user, value: 7)
      }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.message).to eq("Mood was created: Value: 7")
    end
  end
end
