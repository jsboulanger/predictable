require 'active_support/core_ext/hash/keys'
require 'predictionio'

module Predictable
  # == Recommender
  #
  # Defines the Recommender interface and implements it using
  # the Prediction.io API.
  #
  #   recommender = Recommender.new(client)
  #   recommender.create_item(item)
  #   recommender.create_user(user)
  #   recommender.record_action(user, "conversion", item)
  #   recommender.recommended_items(user, 10)
  #
  class Recommender
    attr_reader :client
    attr_accessor :recommendation_engine, :similarity_engine

    def initialize(client, engines={})
      @client = client
      @recommendation_engine = engines[:recommendation_engine]
      @similarity_engine = engines[:similarity_engine]
    end

    def create_item(item, attrs = {})
      client.acreate_item(item.pio_iid, item.pio_itypes, attrs)
    end

    def delete_item(item)
      client.adelete_item(item.pio_iid)
    end

    def create_user(user, attrs = {})
      client.acreate_user(user.pio_uid, attrs)
    end

    def delete_user(user)
      client.adelete_user(user.pio_uid)
    end

    def record_action(user, action, item, opts = {})
      client.identify(user.pio_uid)
      client.arecord_action_on_item(action.to_s, item.pio_iid, opts)
    end

    def recommended_items(user, n, opts = {})
      options = opts.stringify_keys
      client.identify(user.pio_uid)
      begin
        client.get_itemrec_top_n(recommendation_engine, n, opts)
      rescue PredictionIO::Client::ItemRecNotFoundError => e
        []
      end
    end

    def similar_items(item, n, opts = {})
      begin
        client.get_itemsim_top_n(similarity_engine, item.pio_iid, n, opts)
      rescue PredictionIO::Client::ItemSimNotFoundError
        []
      end
    end

  end
end






