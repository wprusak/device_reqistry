# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  # TODO: Implement the tests for ReturnDeviceFromUser
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: user.id
    ).call
  end  
  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  
  context 'when user returns a device' do
    before do
      AssignDeviceToUser.new(
        requesting_user: user,
        serial_number: serial_number,
        new_device_owner_id: user.id
      ).call
    end

    context 'when the device does not exist' do
      let(:serial_number) { 'non_existent_serial' }

      it 'raises an error' do
        expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end  

    context 'when the user does not own the device' do
      let(:other_user) { create(:user) }
      let(:device) { create(:device, serial_number: serial_number, user: other_user) }

      it 'raises an error' do
        expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    context 'when the user owns the device' do
      it 'returns the device successfully' do
        expect { return_device }.not_to raise_error
        expect(user.devices.pluck(:serial_number)).not_to include(serial_number)
      end
    end
  end
end
