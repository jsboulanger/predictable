require 'ostruct'

describe Predictable::User do
  let(:recommender) { Predictable::Recommender.new(double("Client").as_null_object) }

  # TODO: Test with ActiveRecord::Base
  class MyUser < OpenStruct
    include Predictable::User
  end

  before do
    MyUser.recommender = recommender
  end

  let(:user) { MyUser.new(:id => 1) }
  let(:item) { double("Item", :pio_iid => 2) }
  subject { user }

  its(:pio_uid) { should == 1 }

  describe "#record_action" do
    it "should record an action with the recommender" do
      recommender.should_receive(:record_action)
        .with(user, :rate, item, :rating => 4)

      user.record_action(:rate, item, :rating => 4)
    end

    it "should return nil" do
      user.record_action(:rate, item).should be_nil
    end
  end

  describe "#add_to_recommender" do
    it "should create a user in the recommender" do
      recommender.should_receive(:create_user).with(user, {})
      user.add_to_recommender
    end

    it "should return nil" do
      user.add_to_recommender.should be_nil
    end
  end

  describe "#delete_from_recommender" do
    it "should delete the user from the recommender" do
      recommender.should_receive(:delete_user).with(user)
      user.delete_from_recommender
    end

    it "should return nil" do
      user.delete_from_recommender.should be_nil
    end
  end
end
