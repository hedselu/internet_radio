require 'rails_helper'
require_relative '../support/user_setup'

describe PlayersController do
  include Devise::Test::ControllerHelpers

  context 'when user is signed in' do
    let(:user) { user_setup }

    before { sign_in user }

    describe '#create' do
      before { post :create, playlist_id: user.playlists.first.id }

      it 'inserts thread to WorkerContainer' do
        expect(Channels::WorkerContainer.instance.size).to eq 1
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#update' do
      before { post :create, playlist_id: user.playlists.first.id; put :update }
      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#destroy' do
      before { delete :destroy }

      it 'removes thread from WorkerContainer' do
        expect(Channels::WorkerContainer.instance.size).to eq 0
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 204
      end
    end
  end

  context 'when user is not signed in' do
    it 'returns 401 status code' do
      post :create, format: :json
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
    end
  end
end
