require 'rails_helper'

describe SongsController do
  include Devise::Test::ControllerHelpers

  context 'when user is signed in' do
    let(:user) { create(:user_with_songs) }
    before { sign_in user }

    before do
      class SongUploader
        def store_dir
          File.join(Rails.root, 'spec', 'support', 'uploads', model.class.to_s.downcase.pluralize.to_s,
                    model.user.email.to_s, model.author.to_s)
        end
      end
    end

    describe '#index' do
      before { get :index }

      it 'returns all songs for current user' do
        expect(JSON.parse(response.body).size).to eq 5
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#show' do
      before { get :show, id: user.songs.first.id }

      it 'returns selected song for current user' do
        expect(JSON.parse(response.body)['id']).to eq user.songs.first[:id]
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#create' do
      context 'when proper params' do
        before { post :create, songs: { files: [fixture_file_upload('files/ruby_kaiser.mp3', 'audio/mpeg')] } }

        it 'returns all song infos' do
          expect(JSON.parse(response.body)['songs'].first['title']).to eq 'Ruby'
        end

        it 'returns 201 status code' do
          expect(response.status).to eq 201
        end
      end

      context 'when improper params' do
        before { post :create, songs: { files: [fixture_file_upload('files/era_ameno.mp3', 'audio/mpeg')] } }

        it 'returns errors messages' do
          expect(JSON.parse(response.body)['errors']).to eq('title' => ["can't be blank"])
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end
      end
    end

    describe '#destroy' do
      context 'when song exists' do
        before { delete :destroy, id: user.songs.first.id }

        it 'returns nothing in body' do
          expect(response.body).to eq ''
        end

        it 'returns 204 status code' do
          expect(response.status).to eq 204
        end
      end
    end
  end

  context 'when user is not signed in' do
    before { get :index, format: :json }

    it 'returns error message' do
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
    end

    it 'returns 401 status code' do
      expect(response.status).to eq 401
    end
  end
end
