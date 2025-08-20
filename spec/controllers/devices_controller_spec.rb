# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:api_key) { create(:api_key) }
  let(:user) { api_key.bearer }

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { new_owner_id: new_owner_id,  serial_number: '123456' },
           session: { token: user.api_keys.first.token }
    end
    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:new_owner_id) { create(:user).id }

        it 'returns an unauthorized response' do
          assign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user assigns a device to self' do
        let(:new_owner_id) { user.id }

        it 'returns a success response' do
          assign
          expect(response).to be_successful
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :assign
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'POST #unassign' do
    # TODO: implement the tests for the unassign action
    subject(:unassign) do
      post :unassign,
           params: { serial_number: '123456', from_user: user.id },
           session: { token: user.api_keys.first.token }
    end

    context 'when the user is authenticated' do
      context 'when device not exists' do
        it 'returns an error response' do
          unassign
          expect(response.code).to eq("404")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Device not found' })
        end
      end  
      context 'when the user owns the device' do
        let!(:device) { create(:device, serial_number: '123456', user: user) }

        it 'returns a success response' do
          unassign
          expect(response).to be_successful
        end
      end
      context 'when the user does not own the device' do
        let(:other_user) { create(:user) }
        let!(:device) { create(:device, serial_number: '123456', user: other_user) }

        it 'returns an error response' do
          unassign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end
    end
  end
end
