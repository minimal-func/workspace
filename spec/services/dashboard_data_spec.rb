require 'rails_helper'

RSpec.describe DashboardData do
  let(:user) { FactoryBot.create(:user) }
  let(:service) { described_class.new(user) }

  describe '#active_projects' do
    let!(:p_none) { FactoryBot.create(:project, user: user, title: 'No Todos') }
    let!(:p_done) { FactoryBot.create(:project, user: user, title: 'Done Todos') }
    let!(:p_one) { FactoryBot.create(:project, user: user, title: 'One Open') }
    let!(:p_two) { FactoryBot.create(:project, user: user, title: 'Two Open') }
    let!(:p_three) { FactoryBot.create(:project, user: user, title: 'Three Open') }

    before do
      # p_none: 0 todos
      # p_done: 2 finished todos
      FactoryBot.create(:todo, project: p_done, finished: true)
      FactoryBot.create(:todo, project: p_done, finished: true)

      # p_one: 1 open todo, 1 finished
      FactoryBot.create(:todo, project: p_one, finished: false)
      FactoryBot.create(:todo, project: p_one, finished: true)

      # p_two: 2 open todos
      FactoryBot.create(:todo, project: p_two, finished: false)
      FactoryBot.create(:todo, project: p_two, finished: false)

      # p_three: 3 open todos
      FactoryBot.create(:todo, project: p_three, finished: false)
      FactoryBot.create(:todo, project: p_three, finished: false)
      FactoryBot.create(:todo, project: p_three, finished: false)
    end

    it 'orders projects by open todos count descending and limits to 3' do
      expect(service.send(:active_projects)).to eq([p_three, p_two, p_one])
    end

    it 'eager loads todos' do
      projects = service.send(:active_projects)
      expect(projects.first.association(:todos)).to be_loaded
    end

    it 'does not include projects of other users' do
      other_user = FactoryBot.create(:user)
      other_project = FactoryBot.create(:project, user: other_user, title: 'Other')
      FactoryBot.create_list(:todo, 5, project: other_project, finished: false)

      expect(service.send(:active_projects)).not_to include(other_project)
    end
  end

  describe '#open_todos_count' do
    let!(:project) { FactoryBot.create(:project, user: user) }

    it 'returns the count of unfinished todos across user projects' do
      FactoryBot.create(:todo, project: project, finished: false)
      FactoryBot.create(:todo, project: project, finished: false)
      FactoryBot.create(:todo, project: project, finished: true)

      expect(service.send(:open_todos_count)).to eq(2)
    end
  end
end
