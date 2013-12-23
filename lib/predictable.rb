require "predictable/item"
require "predictable/recommender"
require "predictable/user"
require "predictable/version"

module Predictable
  class << self
    def default_config
      {
        :api_url     => "http://localhost:10001",
        :threads     => 10,
        :api_version => ""
      }.dup
    end

    def client
      @client ||= PredictionIO::Client.new(
        config[:app_key],
        config[:threads],
        config[:api_url],
        config[:api_version]
      )
    end

    def config
      @config ||= default_config
    end

    def config=(new_config)
      config.merge!(new_config)
    end

    def engines
      {
        :recommendation_engine => config[:recommendation_engine],
        :similarity_engine => config[:similarity_engine]
      }
    end
  end
end
