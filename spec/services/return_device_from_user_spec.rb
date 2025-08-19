# frozen_string_literal: true

require 'rspec'

RSpec.describe ReturnDeviceFromUser do
  # TODO: Implement the tests for ReturnDeviceFromUser
  subject(:return_device) do
    described_class.new(
      requesting_user: user,
      serial_number: serial_number
    ).call
  end  
  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  let(:device) { create(:device, serial_number: serial_number, user: user) }
  
  context 'when user returns a device' do
    before do
      device
    end

    it 'returns the device successfully' do
      expect { return_device }.not_to raise_error
      expect(device.reload.user).to be_nil
    end

    context 'when the device does not exist' do
      let(:serial_number) { 'non_existent_serial' }

      it 'raises an error' do
        expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context 'when the user does not own the device' do
        let(:other_user) { create(:user) }
        let(:device) { create(:device, serial_number: serial_number, user: other_user) }

        it 'raises an error' do
          expect { return_device }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
end
