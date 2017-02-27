require 'rails_helper'

describe PlaylistsController do
  include Devise::Test::ControllerHelpers

  let(:playlist_attributes) { attributes_for(:playlist) }
  let(:user) { create(:user_with_playlists_list) }

  context 'when user is signed in' do
    before { sign_in user }

    describe '#index' do
      before { get :index }

      it 'returns all playlists for current user' do
        expect(JSON.parse(response.body).size).to eq 5
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#show' do
      before { get :show, id: user.playlists.first.id }

      it 'returns selected playlist for current user' do
        expect(JSON.parse(response.body)['name']).to be_present
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#create' do
      context 'when proper params' do
        before { post :create, playlist: playlist_attributes }

        it 'returns all playlist infos' do
          expect(JSON.parse(response.body)['name']).to eq playlist_attributes[:name]
        end

        it 'returns 200 status code' do
          expect(response.status).to eq 201
        end
      end

      context 'when improper params' do
        before { post :create, playlist: { name: '' } }

        it 'returns error message' do
          expect(JSON.parse(response.body)['errors']['name'].first).to eq "can't be blank"
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end
      end
    end

    describe '#update' do
      context 'when proper params' do
        let(:song1) { create(:song) }
        let(:song2) { create(:song) }

        before { put :update, id: user.playlists.first.id, playlist: { name: 'other_name', song_ids: [song1.id, song2.id] } }

        it 'returns updated playlist name' do
          expect(JSON.parse(response.body)['name']).to eq 'other_name'
        end

        it 'returns playlist updated songs' do
          expect(JSON.parse(response.body)['songs']).not_to be_empty
        end

        it 'returns 200 status code' do
          expect(response.status).to eq 200
        end
      end

      context 'when improper params' do
        before { put :update, id: user.playlists.first.id, playlist: { name: '' } }

        it 'returns errors messages' do
          expect(JSON.parse(response.body)['errors']['name'].first).to eq "can't be blank"
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end
      end
    end

    describe '#destroy' do
      before { delete :destroy, id: user.playlists.first.id }

      it 'returns nothing in body' do
        expect(response.body).to eq ''
      end

      it 'returns 204 status code' do
        expect(response.status).to eq 204
      end
    end
  end

  context 'when user is not signed in' do
    before { get :index, format: :json }

    it 'return error message' do
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
    end

    it 'returns 401 status code' do
      expect(response.status).to eq 401
    end
  end
end
