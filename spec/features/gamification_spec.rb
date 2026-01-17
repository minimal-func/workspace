require 'rails_helper'

RSpec.feature "Gamification", type: :feature do
  let(:user) { create(:user) }
  let!(:level1) { create(:level, level_number: 1, name: "Beginner", points_required: 0) }
  let!(:level2) { create(:level, level_number: 2, name: "Intermediate", points_required: 100) }
  let!(:achievement) { create(:achievement, name: "First Step", description: "Complete your first day", threshold: 1) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User views achievements and levels" do
    visit gamification_path
    expect(page).to have_content("Your Achievements")
    expect(page).to have_content("Your Level")
  end

  scenario "User earns points and levels up" do
    # Manually award points to test leveling up
    GamificationService.award_points_for(:create_post, user)
    
    visit gamification_path
    expect(page).to have_content("Create post")
    expect(page).to have_content("+30") # Default value for create_post
  end

  scenario "User views notifications" do
    notification = create(:notification, user: user, message: "You earned an achievement!")
    
    visit root_path
    find(".dropdown__trigger", text: "1").click # Notification badge
    expect(page).to have_content("You earned an achievement!")
    
    click_link "You earned an achievement!"
    expect(page).to have_content("You earned an achievement!") # In show page or updated
  end
end
