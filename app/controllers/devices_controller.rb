# frozen_string_literal: true
require_relative '../errors/device_errors'

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]

  rescue_from RegistrationError::Unauthorized do |_e|
    render json: { error: 'Unauthorized' }, status: :unprocessable_entity 
  end

  rescue_from ActiveRecord::RecordNotFound do |_e|
    render json: { error: 'Device not found' }, status: :not_found
  end

  def assign
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: params[:serial_number],
      new_device_owner_id: params[:new_owner_id]
    ).call
    head :ok
  end

  def unassign
    ReturnDeviceFromUser.new(
      user: @current_user,
      serial_number: params[:serial_number],
      from_user: params[:from_user]
    ).call

    head :ok
  end
  
  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end
