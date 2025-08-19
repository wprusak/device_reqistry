class MakeUserIdNullableInDevices < ActiveRecord::Migration[8.0]
  def change
    change_column_null :devices, :user_id, true
  end
end
