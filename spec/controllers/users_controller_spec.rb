require 'rails_helper'

describe UsersController do
  include Devise::Test::ControllerHelpers

  context 'when user is looged in' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe '#show' do
      before { get :show, format: :json }

      it 'shows data of current user' do
        expect(JSON.parse(response.body)['email']).to eq 'sample_email@mail.com'
      end

      it 'shows returns 200 status code' do
        expect(response.status).to eq 200
      end
    end

    describe '#update' do
      context 'with proper params' do
        before { put :update, user: { email: 'another@mail.com' } }

        it 'updates user data' do
          expect(JSON.parse(response.body)['email']).to eq 'another@mail.com'
        end

        it 'returns 201 status code' do
          expect(response.status).to eq 200
        end
      end

      context 'with improper params' do
        it 'updates user data' do
          put :update, user: { email: 'another' }
          expect(JSON.parse(response.body)['email']).to eq ['is invalid']
        end
      end
    end

    describe '#destroy' do
      it 'destroys user' do
        delete :destroy
        expect(response.status).to eq 204
      end
    end
  end

  context 'when user is not logged in' do
    before { get :show, format: :json }

    it 'returns error message' do
      expect(JSON.parse(response.body)).to eq('error' => 'You need to sign in or sign up before continuing.')
    end

    it 'returns 401 status code' do
      expect(response.status).to eq 401
    end
  end
end
