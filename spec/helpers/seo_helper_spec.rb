require 'rails_helper'

RSpec.describe SeoHelper, type: :helper do
  before do
    # Default request mock
    allow(helper).to receive(:request).and_return(
      double('Request', path: '/', protocol: 'https://', host: 'myday.ildarsafin.tech')
    )
    allow(helper).to receive(:user_signed_in?).and_return(false)
    allow(helper).to receive(:controller_name).and_return('landing')
    allow(helper).to receive(:controller_path).and_return('landing')
  end

  describe '#meta_title' do
    it 'returns provided content_for(:title) when set' do
      helper.content_for(:title, 'Custom Title | MyDay')
      expect(helper.meta_title).to eq('Custom Title | MyDay')
    end

    it 'returns default title when nothing set' do
      expect(helper.meta_title).to include('MyDay')
    end

    it 'uses @app_title if available and no content_for' do
      assign(:app_title, 'Personal Productivity')
      expect(helper.meta_title).to eq('MyDay.Personal Productivity')
    end
  end

  describe '#meta_description' do
    it 'returns content_for(:meta_description) when set' do
      helper.content_for(:meta_description, 'A great productivity app.')
      expect(helper.meta_description).to eq('A great productivity app.')
    end

    it 'returns default description' do
      expect(helper.meta_description).to include('MyDay helps you build a life')
    end
  end

  describe '#meta_robots' do
    it 'allows indexing for public pages when not signed in' do
      expect(helper.meta_robots).to include('index, follow')
    end

    it 'blocks indexing when user is signed in' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/dashboards')
      )
      allow(helper).to receive(:controller_name).and_return('dashboards')
      allow(helper).to receive(:controller_path).and_return('dashboards')
      expect(helper.meta_robots).to eq('noindex, nofollow, noarchive')
    end

    it 'blocks indexing on login/devise paths' do
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/users/sign_in')
      )
      allow(helper).to receive(:controller_name).and_return('sessions')
      allow(helper).to receive(:controller_path).and_return('users/sessions')
      expect(helper.meta_robots).to eq('noindex, nofollow, noarchive')
    end
  end

  describe '#canonical_url' do
    it 'normalizes /landing to root domain' do
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/landing')
      )
      expect(helper.canonical_url).to eq('https://myday.ildarsafin.tech')
    end

    it 'returns clean URL for /help' do
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/help')
      )
      expect(helper.canonical_url).to eq('https://myday.ildarsafin.tech/help')
    end
  end

  describe '#json_ld_structured_data' do
    it 'renders WebSite and WebApplication schemas for landing page' do
      html = helper.json_ld_structured_data
      expect(html).to include('"@type":"WebSite"')
      expect(html).to include('"@type":"WebApplication"')
      expect(html).to include('MyDay')
    end

    it 'renders FAQPage schema for /help' do
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/help')
      )
      html = helper.json_ld_structured_data
      expect(html).to include('"@type":"FAQPage"')
      expect(html).to include('What is MyDay and what is it for?')
    end

    it 'renders nil for private pages' do
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:request).and_return(
        double('Request', path: '/dashboards')
      )
      allow(helper).to receive(:controller_name).and_return('dashboards')
      allow(helper).to receive(:controller_path).and_return('dashboards')
      expect(helper.json_ld_structured_data).to be_nil
    end
  end
end
