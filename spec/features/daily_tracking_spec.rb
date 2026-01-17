require 'rails_helper'

RSpec.feature "Daily Tracking", type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
    visit root_path
  end

  scenario "User sets main task" do
    click_link "Set my main task"
    fill_in "main_task_name", with: "Complete Capybara tests"
    fill_in "main_task_planned_finish", with: 1.day.from_now.to_date
    click_button "Save"

    expect(page).to have_content("Complete Capybara tests")
  end

  scenario "User fills in daily tracking form", js: false do
    # Skip JS for now as it uses EditorJS
    within("form") do
      # Radio buttons might be hidden or styled
      first("label", text: "8").click
      all("label", text: "7").last.click
      all("label", text: "9").last.click
      
      fill_in "Today's Biggest Challenge:", with: "Staying focused"
      fill_in "One Important thing I learned today:", with: "Capybara is useful"
      fill_in "Today I am grateful for:", with: "Good coffee"
      click_button "Save my day"
    end

    expect(page).to have_content("Profile updated")
  end
end
