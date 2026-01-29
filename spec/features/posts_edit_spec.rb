require 'rails_helper'

RSpec.feature "Post editing", type: :feature do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:post_record) { create(:post, project: project) }

  before do
    login_as(user, scope: :user)
  end

  scenario "Edit post page uses the standard layout" do
    visit edit_project_post_path(project, post_record)

    expect(page).to have_content("Edit post")
    expect(page).to have_css(".post-form-page .post-form")
    expect(page).to have_css(".post-form-page .post-form .row .col-12")
    expect(page).to have_css("#post-editor")
  end
end
