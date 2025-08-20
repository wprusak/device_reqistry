# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: from_user
    ).call
  end  

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  let(:from_user) { user.id }
  
  context 'when user returns a device' do
    context 'when the device does not exist' do
      let(:serial_number) { 'non_existent_serial' }

      it 'raises an error' do
        expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end  
    context 'when the user does not own the device' do

      let(:from_user) { create(:user).id }
      it 'raises an error' do
        expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user owns the device' do
      let!(:device) { create(:device, serial_number: serial_number, user: user) }
      it 'returns the device successfully' do
        expect { return_device }.not_to raise_error
        device = Device.find_by(serial_number: serial_number)
        expect(device.user_id).to be_nil
        expect(device.returned_by_id).to eq(user.id)
      end
    end
  end
end
