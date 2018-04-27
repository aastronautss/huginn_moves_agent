# frozen_string_literal: true

##
# A mixin for adding Moves API functionality to Huginn agents.
#
module MovesAgentable
  extend ActiveSupport::Concern

  included do
    include FormConfigurable
    include Oauthable

    valid_oauth_providers :moves

    gem_dependency_check do
      defined?(Moves::Client) &&
        Devise.omniauth_providers.include?(:moves) &&
        ENV['MOVES_OAUTH_KEY'].present? &&
        ENV['MOVES_OAUTH_SECRET'].present?
    end

    description <<~MD
      To be able to use this Agent you need to authenticate with Moves in the [Services](/services) section first.
    MD
  end

  module ClassMethods
    def moves_dependencies_missing
      if ENV['MOVES_OAUTH_KEY'].blank? || ENV['MOVES_OAUTH_SECRET'].blank?
        '## Set MOVES_OAUTH_KEY and MOVES_OAUTH_SECRET in your environment to use Moves agents.'
      elsif !defined?(Moves) || !Devise.omniauth_providers.include?(:moves)
        '## Include `moves` and `omniauth-moves` in your Gemfile to use Moves agents.'
      end
    end
  end

  def validate_options
    return if moves_oauth_token.present?

    errors.add(:base, 'You need to authenticate with Moves in the Services section')
  end

  def moves_consumer_key
    (config = Devise.omniauth_configs[:moves]) && config.strategy.consumer_key
  end

  def moves_consumer_secret
    (config = Devise.omniauth_configs[:moves]) && config.strategy.consumer_secret
  end

  def moves_oauth_token
    service&.token
  end

  def moves
    Moves::Client.new(moves_oauth_token)
  end
end
