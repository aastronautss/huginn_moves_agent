# frozen_string_literal: true

##
# A service to connect to the Moves API.
#
class MovesService < Service
  class << self
    def provider_specific_options(*_args)
      { name: 'Moves User' }
    end
  end
end
