require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:todos).dependent(:destroy) }
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:saved_links).dependent(:destroy) }
    it { is_expected.to have_many(:materials).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe ".ordered_by_open_todos" do
    let(:user) { FactoryBot.create(:user) }
    let!(:project_with_no_todos) { FactoryBot.create(:project, user: user, title: "Zero Todos") }
    let!(:project_with_finished_todos) { FactoryBot.create(:project, user: user, title: "Finished Todos") }
    let!(:project_with_one_open) { FactoryBot.create(:project, user: user, title: "One Open") }
    let!(:project_with_two_open) { FactoryBot.create(:project, user: user, title: "Two Open") }

    before do
      FactoryBot.create(:todo, project: project_with_finished_todos, finished: true)
      FactoryBot.create(:todo, project: project_with_one_open, finished: false)
      FactoryBot.create(:todo, project: project_with_one_open, finished: true)
      FactoryBot.create(:todo, project: project_with_two_open, finished: false)
      FactoryBot.create(:todo, project: project_with_two_open, finished: false)
    end

    it "orders projects by the number of open (unfinished) todos descending" do
      expect(user.projects.ordered_by_open_todos).to eq([
        project_with_two_open,
        project_with_one_open,
        project_with_finished_todos,
        project_with_no_todos
      ])
    end
  end
end