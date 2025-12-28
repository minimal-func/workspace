require 'rails_helper'

RSpec.feature "Projects and Timetracker", type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "User creates a project and adds components" do
    visit timetracker_projects_path
    click_link "New Project"
    fill_in "Project Title", with: "Test Project"
    click_button "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Test Project")

    # Add a Todo
    click_link "New Todo"
    fill_in "Content", with: "First Todo"
    click_button "Create Todo"
    expect(page).to have_content("First Todo")

    # Add a Task
    click_link "New Task"
    fill_in "Name", with: "First Task"
    click_button "Create Task"
    expect(page).to have_content("First Task")
  end

  scenario "User tracks time for a task" do
    project = create(:project, user: user)
    task = create(:task, project: project)

    visit timetracker_project_path(project)
    
    # Starting a task might be a bit complex to test with Capybara if it's JS heavy
    # but let's see if there's a simple link
    click_link "Start"
    expect(page).to have_content("Stop")
    
    click_link "Stop"
    expect(page).to have_content("Start")
    expect(page).to have_css(".time-spent") # Assuming there's some display of time
  end
end
