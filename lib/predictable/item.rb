require 'active_support/concern'
require 'active_support/inflector'

module Predictable
  # == Predictable Item Role
  #
  # Defines the Item role for the recommender. This module should
  # be included in any model that represents items that will
  # be recommended.
  #
  #   class Offer < ActiveRecord::Base
  #     include Predictable::Item
  #     ...
  #   end
  #
  #   class Article < ActiveRecord::Base
  #     include Predictable::Item
  #     ...
  #   end
  #
  module Item
    extend ActiveSupport::Concern

    # Returns the item id
    def pio_iid
      "#{self.class.pio_itype}-#{id}"
    end

    # Returns the item types
    def pio_itypes
      [self.class.pio_itype]
    end

    # Creates or updates the item in prediction.io
    # When the item already exists, it updates it.
    # The operation is done asynchronously.
    def add_to_recommender(attrs={})
      recommender.create_item(self, attrs)
      nil
    end

    # Removes the item from prediction.io
    # The operation is done asynchronously.
    def delete_from_recommender
      recommender.delete_item(self)
      nil
    end

    protected

    def recommender
      self.class.recommender
    end

    module ClassMethods
      attr_writer :pio_engines, :recommender

      def pio_engines
        @pio_engines || Predictable.engines
      end

      def recommender
        @recommender ||= Recommender.new(Predictable.client, pio_engines)
      end

      def pio_itype
        to_s.underscore
      end

      def recommended_for(user, n, opts={})
        options = { "itypes" => [pio_itype] }.merge(opts)

        item_ids = recommender.recommended_items(user, n, options)
        item_ids = item_ids.map { |id| id.gsub! /[^\d]/, '' }
        where(:id => item_ids)
      end

      def similar_to(item, n, opts={})
        options = opts.stringify_keys
        options["pio_itypes"] ||= [pio_itype]
        limit = options.delete("limit") || 100

        item_ids = recommender.similar_items(item, n, options)
        item_ids = item_ids.map { |id| id.gsub! /[^\d]/, '' }
        where(:id => item_ids)
      end

    end
  end
end
