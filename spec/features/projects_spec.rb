require 'rails_helper'

RSpec.feature "Projects and Timetracker", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user, title: "Test Project") }

  before do
    login_as(user, scope: :user)
  end

  scenario "User sees mascot guidance on the project dashboard" do
    visit timetracker_projects_path

    expect(page).to have_content("Sunny's project desk")
    expect(page).to have_content("Open a project and Sunny will help you connect tasks, notes, files, and links around the same goal.")
  end

  scenario "User creates a project and lands in a mascot-guided workspace" do
    visit timetracker_projects_path
    click_link "New Project"
    fill_in "Project Title", with: "Test Project"
    click_button "Create Project"

    expect(page).to have_content("Test Project")
    expect(page).to have_content("Sunny's project desk")
    expect(page).to have_content("Start the project with a task and Sunny will turn it into visible momentum across the whole workspace.")
  end

  scenario "User sees mascot guidance on project resource pages" do
    visit project_posts_path(project)

    expect(page).to have_content("Sunny's project desk")
    expect(page).to have_content("Capture a quick update, decision, or lesson here so the project history stays readable.")
  end
end
