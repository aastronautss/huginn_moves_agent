# frozen_string_literal: true

module Agents
  ##
  # = Huginn MovesCurrentLocationAgent
  #
  class MovesCurrentLocationAgent < Agent
    include MovesAgentable

    T_PLACE = 'place'
    T_MOVE = 'move'

    cannot_receive_events!

    description <<~MD
      The Moves Current Location agent pulls the most recent location from your Moves app.

      #{moves_dependencies_missing if dependencies_missing?}

      To be able to use this Agent you need to authenticate with Moves in the [Services](/services) section first.
    MD

    default_schedule 'every_1h'

    def check
      day = Date.current
      storyline = moves.daily_storyline(trackpoints: true, from: day, to: day).map(&:with_indifferent_access)

      most_recent_day = most_recent_hash(storyline)
      most_recent_segment = most_recent_hash(most_recent_day[:segments], key: 'endTime', parser: Time)
      lat, lon = location_data_from_segment(most_recent_segment)

      create_event payload: { latitude: lat, longitude: lon }
    end

    private

    def most_recent_hash(ary, key: :date, parser: Date)
      ary.max_by { |ele| parser.parse(ele[key]) }
    end

    def location_data_from_segment(segment)
      case segment[:type]
      when T_PLACE
        location_data_for_place(segment)
      when T_MOVE
        location_data_for_move(segment)
      else
        [nil, nil]
      end
    end

    def location_data_for_place(segment)
      location_data = segment[:place][:location]

      [location_data[:lat], location_data[:lon]]
    end

    def location_data_for_move(segment)
      most_recent_activity = most_recent_hash(segment[:activities], key: 'endTime', parser: Time)
      most_recent_trackpoint = most_recent_hash(most_recent_activity[:trackpoints], key: :time, parser: Time)

      [most_recent_trackpoint[:lat], most_recent_trackpoint[:lon]]
    end
  end
end

# "latitude": "37.12345",
# "longitude": "-122.12345",
# "timestamp": "123456789.0",
# "altitude": "22.0",
# "horizontal_accuracy": "5.0",
# "vertical_accuracy": "3.0",
# "speed": "0.52595",
# "course": "72.0703",
# "device_token": "..."
