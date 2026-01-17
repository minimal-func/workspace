require 'rails_helper'

RSpec.feature "Navigation", type: :feature do
  let(:user) { create(:user) }

  scenario "Visitor sees landing page" do
    visit root_path
    expect(page).to have_content("Track Your Personal Growth")
    expect(page).to have_link("Sign Up")
    expect(page).to have_link("Log In")
  end

  scenario "Logged in user sees dashboard" do
    login_as(user, scope: :user)
    visit root_path
    expect(page).to have_content("You did not set your main task yet")
    expect(page).to have_content("My mood today")
  end

  scenario "User navigates through history" do
    login_as(user, scope: :user)
    visit root_path
    
    find(".dropdown__trigger", text: "History").click
    click_link "Reflections"
    expect(page).to have_content("My Reflections")
    
    find(".dropdown__trigger", text: "History").click
    click_link "Day Ratings"
    expect(page).to have_content("Day Ratings")
  end
end
