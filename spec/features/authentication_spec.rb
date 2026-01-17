require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  let(:user) { create(:user) }

  scenario "User logs in with valid credentials" do
    visit new_user_session_path
    fill_in "Your email", with: user.email
    fill_in "Your password", with: user.password
    click_button "Login"

    expect(page).to have_content("Signed in successfully.")
    expect(page).to have_content(user.email)
  end

  scenario "User logs out" do
    login_as(user, scope: :user)
    visit root_path
    
    # Based on the header structure I saw earlier
    find(".dropdown__trigger", text: user.email).click
    click_link "Log out"

    expect(page).to have_link("Login")
  end

  scenario "User signs up" do
    visit new_user_registration_path
    fill_in "Your email", with: "newuser@example.com"
    fill_in "Your password", with: "password123"
    fill_in "Confirm password", with: "password123"
    click_button "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully.")
  end
end
