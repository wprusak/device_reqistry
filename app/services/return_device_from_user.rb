# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(requesting_user:, serial_number:)
    # TODO
    @requesting_user = requesting_user
    @serial_number = serial_number
  end

  def call
    # TODO
    device = find_device
    # Check if the device exists
    raise ActiveRecord::RecordNotFound, "Device with serial number #{@serial_number} not found." unless device_exists?

    # Check if the requesting user owns the device
    unless user_owns_device?(device)
      raise ActiveRecord::RecordNotFound, "User does not own the device with serial number #{@serial_number}."
    end

    # Proceed to return the device
    return_device(device)
  end
  
  private

  def find_device
    Device.find_by(serial_number: @serial_number)
  end

  def return_device(device)
    device.update!(user: nil, returned_by: @requesting_user)
  end
  
  def user_owns_device?(device)
    device.user_id == @requesting_user.id
  end

  def device_exists?
    Device.exists?(serial_number: @serial_number)
  end
end
