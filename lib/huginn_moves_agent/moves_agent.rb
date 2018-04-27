# frozen_string_literal: true

module Agents
  ##
  # = Huginn MovesAgent
  #
  class MovesAgent < Agent
    validates_presence_of :service_id

    cannot_receive_events!

    description <<~MD
      The Moves Agent pulls location data from your Moves app.

      #{moves_dependencies_missing if dependencies_missing?}
    MD

    default_schedule 'every_1h'

    class << self
      def moves_dependencies_missing
        if ENV['MOVES_OAUTH_KEY'].blank? || ENV['MOVES_OAUTH_SECRET'].blank?
          '## Set MOVES_OAUTH_KEY and MOVES_OAUTH_SECRET in your environment to use Moves agents.'
        elsif !defined?(Moves) || !Devise.omniauth_providers.include?(:moves)
          '## Include `moves` and `omniauth-moves` in your Gemfile to use Moves agents.'
        end
      end
    end
  end
end
