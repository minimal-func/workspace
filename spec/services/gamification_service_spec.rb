require 'rails_helper'

RSpec.describe GamificationService, type: :service do
  describe "POINT_VALUES" do
    it "defines point values for actions" do
      expect(GamificationService::POINT_VALUES).to include(
        create_project: 50,
        create_task: 10,
        complete_task: 20,
        create_post: 30,
        create_todo: 10,
        complete_todo: 20,
        create_saved_link: 10,
        create_material: 20
      )
    end
  end

  describe ".award_points_for" do
    let(:user) { FactoryBot.create(:user) }

    context "with a valid action" do
      it "awards points to the user" do
        expect {
          GamificationService.award_points_for(:create_project, user)
        }.to change { user.points.count }.by(1)
      end

      it "awards the correct number of points" do
        GamificationService.award_points_for(:create_project, user)
        expect(user.points.last.value).to eq(50)
      end
    end

    context "with an invalid action" do
      it "does nothing" do
        expect {
          GamificationService.award_points_for(:invalid_action, user)
        }.not_to change { user.points.count }
      end
    end

    context "with a nil user" do
      it "does nothing" do
        expect {
          GamificationService.award_points_for(:create_project, nil)
        }.not_to change { Point.count }
      end
    end
  end

  describe ".check_action_achievements" do
    let(:user) { FactoryBot.create(:user) }

    context "when threshold is met" do
      let!(:achievement) do
        FactoryBot.create(:achievement, achievement_type: 'project_created', threshold: 1)
      end

      it "awards the achievement" do
        FactoryBot.create(:point, user: user, action: 'create_project')
        GamificationService.check_action_achievements('create_project', user)
        expect(user.achievements).to include(achievement)
      end
    end

    context "when threshold is not met" do
      let!(:achievement) do
        FactoryBot.create(:achievement, achievement_type: 'project_created', threshold: 5)
      end

      it "does not award the achievement" do
        GamificationService.check_action_achievements('create_project', user)
        expect(user.achievements).not_to include(achievement)
      end
    end
  end
end
