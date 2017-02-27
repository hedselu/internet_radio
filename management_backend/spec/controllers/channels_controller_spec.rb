require 'rails_helper'

describe ChannelsController do
  include Devise::Test::ControllerHelpers

  context 'when user is signed in' do
    describe '#index' do
      let(:user) { create(:user_with_channel) }
      before do
        sign_in user
        get :index
      end

      it 'returns channel info' do
        expect(JSON.parse(response.body)['name']).to eq 'channel_name'
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#create' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when params are valid' do
        before { post :create, channel: { name: 'test_name' } }

        it 'returns created channel info' do
          expect(JSON.parse(response.body)['name']).to eq 'test_name'
        end

        it 'returns 201 status code' do
          expect(response.status).to eq 201
        end
      end

      context 'when params are invalid' do
        before { post :create, channel: { name: '' } }

        it 'returns error messages' do
          expect(JSON.parse(response.body)['errors']).to be_present
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end
      end
    end

    describe '#update' do
      let(:user) { create(:user_with_channel) }
      before { sign_in user }

      context 'when params are valid' do
        before { put :update, channel: { name: 'another_name' } }

        it 'returns updated channel info' do
          expect(JSON.parse(response.body)['name']).to eq 'another_name'
        end

        it 'returns 200 status code' do
          expect(response.status).to eq 200
        end
      end

      context 'when params are invalid' do
        before { put :update, channel: { name: '' } }

        it 'returns error messages' do
          expect(JSON.parse(response.body)['errors']).to be_present
        end

        it 'returns 422 status code' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  context 'when user in not signed in' do
    before { get :index, format: :json }

    it 'returns error message' do
      expect(JSON.parse(response.body)['error']).to be_present
    end

    it 'returns 401 status code' do
      expect(response.status).to eq 401
    end
  end
end
