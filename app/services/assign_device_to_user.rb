require_relative '../errors/device_errors'
class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    device = Device.find_by(serial_number: @serial_number)
    # if device exists and is already assigned to another user, raise an error
    if device && device_already_assigned?(device)
      raise AssigningError::AlreadyUsedOnOtherUser, "Device with serial number #{@serial_number} is already assigned to another user."
    end

    # Raise custom error if user is not allowed
    unless user_allowed_to_assign? && !user_already_has_device?
      raise RegistrationError::Unauthorized, "User is not allowed to assign this device or already owns it."
    end

    # Create device if it doesn't exist
    device ||= create_device

    # Update the device owner
    update_device_owner(device)
  end

  private

  def update_device_owner(device)
    device.update!(user_id: @new_device_owner_id)
  end

  def user_allowed_to_assign?
    @requesting_user.id == @new_device_owner_id
  end

  def user_already_has_device?
    Device.exists?(user_id: @new_device_owner_id, serial_number: @serial_number)
  end

  def device_already_assigned?(device)
    device.user_id.present?
  end

  def create_device
    Device.create!(serial_number: @serial_number, user_id: @new_device_owner_id)
  end
end
