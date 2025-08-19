class Device < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :returned_by, class_name: 'User', optional: true

    def assigned?  
        user.present?
    end
end
