require 'rails_helper'

describe StatisticsController do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user_with_channel) }
  let(:status) { Icecast::Status.new('some channel') }
  let(:icecast_url) { "http://#{ENV.fetch('ICECAST_HOST')}:#{ENV.fetch('ICECAST_PORT')}#{Icecast::Status::PATH}" }
  let(:now_playing) { { 'icestats' => { 'source' => { 'title' => 'Kaiser Chiefs - Ruby', 'listeners' => 1 } } }.to_json }

  describe '#show' do
    before do
      sign_in user
      stub_request(:get, icecast_url).to_return(body: now_playing)
    end

    it 'renders now playing artist and title' do
      get :show
      expect(JSON.parse(response.body)['now_playing']).to eq 'Kaiser Chiefs - Ruby'
      expect(JSON.parse(response.body)['listeners']).to eq 1
    end
  end
end
