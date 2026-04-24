require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#mascot_action_for' do
    it 'maps project sections to distinct mascot actions' do
      expect(helper.mascot_action_for(:tasks)).to eq(:focus)
      expect(helper.mascot_action_for(:posts)).to eq(:write)
      expect(helper.mascot_action_for(:materials)).to eq(:organize)
      expect(helper.mascot_action_for(:links)).to eq(:explore)
    end

    it 'maps journal sections to distinct mascot actions' do
      expect(helper.mascot_action_for(:daily_gratitudes)).to eq(:heart)
      expect(helper.mascot_action_for(:daily_lessons)).to eq(:learn)
      expect(helper.mascot_action_for(:biggest_challenges)).to eq(:brave)
    end

    it 'falls back to wave for unknown sections' do
      expect(helper.mascot_action_for(:unknown)).to eq(:wave)
    end
  end

  describe '#project_mascot_payload' do
    it 'includes the page action in the payload' do
      payload = helper.project_mascot_payload(
        section: :posts,
        items_count: 0,
        empty_message: 'Capture the work'
      )

      expect(payload[:action]).to eq(:write)
    end
  end

  describe '#journal_mascot_payload' do
    it 'includes the page action in the payload' do
      payload = helper.journal_mascot_payload(section: :daily_gratitudes, items_count: 0)

      expect(payload[:action]).to eq(:heart)
    end
  end
end
