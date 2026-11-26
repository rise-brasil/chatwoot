require 'rails_helper'

RSpec.describe 'Dashboard framing' do
  it 'keeps the dashboard same-origin only when no site is configured' do
    with_modified_env DASHBOARD_FRAME_ANCESTORS: nil do
      get '/app/login'
    end

    expect(response).to have_http_status(:success)
    expect(response.headers['X-Frame-Options']).to eq('SAMEORIGIN')
    expect(response.headers['Content-Security-Policy']).to be_nil
  end

  it 'lets the configured sites frame the dashboard' do
    with_modified_env DASHBOARD_FRAME_ANCESTORS: 'https://sistema.example.com, https://painel.example.com' do
      get '/app/login'
    end

    expect(response).to have_http_status(:success)
    expect(response.headers['X-Frame-Options']).to be_nil
    expect(response.headers['Content-Security-Policy']).to eq("frame-ancestors 'self' https://sistema.example.com https://painel.example.com")
  end

  it 'leaves API responses alone' do
    with_modified_env DASHBOARD_FRAME_ANCESTORS: 'https://sistema.example.com' do
      get '/api'
    end

    expect(response.headers['Content-Security-Policy']).to be_nil
  end
end
