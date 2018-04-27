# frozen_string_literal: true

require 'huginn_moves_agent/version'
require 'huginn_agent'

# Load the +moves+ gem, ignoring LoadErrors. This will allow Huginn to load successfully, showing "Missing Gems"
begin
  require 'moves'
  require 'devise'
  require 'oauth-moves'
rescue LoadError
  HuginnMovesAgent.no_op
end

##
# Auxiliary namespace for +HuginnMovesAgent+
#
module HuginnMovesAgent
  class << self
    def no_op
    end
  end

  I18n.load_path << "#{File.dirname(__FILE__)}/locales/devise.en.yml"

  Devise.setup do |config|
    key = ENV['MOVES_OAUTH_KEY']
    secret = ENV['MOVES_OAUTH_SECRET']

    config.omniauth(:moves, key, secret) if defined?(OmniAuth::Strategies::Moves) && key.present? && secret.present?
  end
end

HuginnAgent.load 'huginn_moves_agent/concerns/moves_agentable'
HuginnAgent.load 'huginn_moves_agent/service_option'
HuginnAgent.register 'huginn_moves_agent/moves_agent'
