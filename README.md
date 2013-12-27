# Predictable

Predictable is a Ruby DSL for Prediction.io, an open source machine learning server built on top of Hadoop. It makes it easy to implement predictive features such as personalization, recommendations, and content discovery in your Ruby/Rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'predictable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install predictable

## Usage

Include Predictable::User in your application's User model.

    class User < ActiveRecord::Base
      include Predictable::User

      ...
    end

Include the Predictable::Item in the models of the items you want to recommend.

    class Offer < ActiveRecord::Base
      include Predictable::Item

      ...
    end

Get 10 recommended items for a user.

    Offer.recommended_for(user, 10)

 Get 10 items most similar to an existing item.

    Offer.similar_to(offer, 10)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
