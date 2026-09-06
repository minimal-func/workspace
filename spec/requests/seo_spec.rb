require 'rails_helper'

RSpec.describe 'SEO integration', type: :request do
  describe 'GET /robots.txt' do
    it 'serves robots.txt with disallow rules and sitemap link' do
      get '/robots.txt'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('User-agent: *')
      expect(response.body).to include('Disallow: /admin/')
      expect(response.body).to include('Disallow: /dashboards')
      expect(response.body).to include('Sitemap: https://myday.ildarsafin.tech/sitemap.xml')
    end
  end

  describe 'GET /sitemap.xml' do
    it 'serves valid sitemap XML with public pages' do
      get '/sitemap.xml'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<urlset')
      expect(response.body).to include('https://myday.ildarsafin.tech/')
      expect(response.body).to include('https://myday.ildarsafin.tech/help')
      expect(response.body).to include('https://myday.ildarsafin.tech/waiting_list/new')
    end
  end

  describe 'GET /landing' do
    it 'includes full SEO meta tags and structured data' do
      get '/landing'
      expect(response).to have_http_status(:ok)

      body = response.body
      # Meta tags
      expect(body).to include('<title>MyDay — Daily Productivity, Wellbeing &amp; Habit Reflection Tracker</title>')
      expect(body).to include('name="description"')
      expect(body).to include('name="keywords"')
      expect(body).to include('content="index, follow')
      expect(body).to include('<link rel="canonical" href="https://myday.ildarsafin.tech/"')

      # Open Graph
      expect(body).to include('property="og:site_name" content="MyDay"')
      expect(body).to include('property="og:title"')
      expect(body).to include('property="og:description"')
      expect(body).to include('property="og:image"')

      # Twitter Cards
      expect(body).to include('name="twitter:card" content="summary_large_image"')

      # JSON-LD Schema.org
      expect(body).to include('application/ld+json')
      expect(body).to include('"@type":"WebSite"')
      expect(body).to include('"@type":"WebApplication"')
    end
  end

  describe 'GET /help' do
    it 'includes FAQPage structured data' do
      get '/help'
      expect(response).to have_http_status(:ok)

      body = response.body
      expect(body).to include('<title>Help &amp; Knowledge Base — MyDay Personal Productivity</title>')
      expect(body).to include('https://myday.ildarsafin.tech/help')
      expect(body).to include('"@type":"FAQPage"')
      expect(body).to include('What is MyDay and what is it for?')
    end
  end

  describe 'GET /waiting_list/new' do
    it 'includes proper meta tags on onboard layout' do
      get '/waiting_list/new'
      expect(response).to have_http_status(:ok)

      body = response.body
      expect(body).to include('<title>Join the Waiting List — MyDay</title>')
      expect(body).to include('name="description"')
      expect(body).to include('<link rel="canonical" href="https://myday.ildarsafin.tech/waiting_list/new"')
    end
  end

  describe 'GET /users/sign_in' do
    it 'sets noindex, nofollow on auth pages' do
      get '/users/sign_in'
      expect(response).to have_http_status(:ok)

      body = response.body
      expect(body).to include('name="robots" content="noindex, nofollow, noarchive"')
    end
  end
end
