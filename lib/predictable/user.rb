require 'active_support/concern'

module Predictable
  # == Predictable User Role
  #
  # Defines the User role for the recommender. This module should
  # be included in the User model of the appliation.
  #
  #   class User < ActiveRecord::Base
  #     include Predictable::User
  #     ...
  #   end
  #
  module User
    extend ActiveSupport::Concern

    # Returns the user id
    def pio_uid
      self.id
    end

    # Record a user action in the recommender.
    # Actions cannot be overwritten or deleted in prediction.io
    # The operation is done asynchronously.
    #
    #   user.record_action(:conversion, item)
    #
    def record_action(action, item, opts={})
      recommender.record_action(self, action, item, opts)
      nil
    end

    def record_conversion(item, opts={})
      record_action(:conversion, item, opts)
      nil
    end

    # Creates or updates a user in prediction.io
    # When the user id already exists it updates the user.
    # The operation is done asynchronously.
    def add_to_recommender(attrs={})
      recommender.create_user(self, attrs)
      nil
    end

    # Removes the user from prediction.io.
    # The operation is done asynchronously.
    def delete_from_recommender
      recommender.delete_user(self)
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
    end
  end
end

