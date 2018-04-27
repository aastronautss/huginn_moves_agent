# frozen_string_literal: true

module Agents
  ##
  # = Huginn MovesAgent
  #
  class MovesAgent < Agent
    cannot_receive_events!

    description <<~MD
      The Moves Agent pulls location data from your Moves app.

      #{moves_dependencies_missing if dependencies_missing?}
    MD

    default_schedule 'every_1d'
  end
end
