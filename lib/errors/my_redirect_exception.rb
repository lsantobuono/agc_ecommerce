module Errors
  class MyRedirectException < StandardError
    attr_accessor :path, :error_message

    def initialize(path, error_message)
      self.path = path
      self.error_message = error_message
    end
  end
end
