module RegistrationError
  class Unauthorized < StandardError; end
end

module AssigningError
  class AlreadyUsedOnUser < StandardError; end
  class AlreadyUsedOnOtherUser < StandardError; end
end

module ReturnError
  class Unauthorized < StandardError; end
  class NotAssigned < StandardError; end
end