# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user = user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call
    device = find_device
    
    # Check if the device exists
    raise ActiveRecord::RecordNotFound, "Device with serial number #{@serial_number} not found" unless device
    
    # Check if the requesting user owns the device
    unless user_owns_device?(device)
      raise RegistrationError::Unauthorized, "User is not allowed to assign this device."
    end

    # Proceed to return the device
    return_device(device)
  end
  
  private

  def find_device
    Device.find_by(serial_number: @serial_number)
  end

  def return_device(device)
    device.update!(user_id: nil, returned_by_id: @from_user)
    device
  end
  
  def user_owns_device?(device)
    device.user_id == @user.id
  end
end