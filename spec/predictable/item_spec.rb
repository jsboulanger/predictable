require 'ostruct'

describe Predictable::Item do
  let(:recommender) { Predictable::Recommender.new(double("Client").as_null_object) }

  # TODO: Test with ActiveRecord::Base
  class MyItem < OpenStruct # ActiveRecord::Base
    include Predictable::Item

    def self.where(args)
      args[:id].map do |i|
        self.new(:id => i.to_i)
      end
    end
  end

  let(:item) { MyItem.new(:id => 1) }
  let(:user) { double("User", :pio_uid => 2) }

  before do
    MyItem.recommender = recommender
  end
  subject { item }

  its(:pio_iid) { should == "my_item-#{item.id}" }
  its(:pio_itypes) { should == ['my_item'] }

  describe "#add_to_recommender" do
    it "should create the item in the recommender" do
      recommender.should_receive(:create_item).with(item, {})
      item.add_to_recommender
    end

    it "should return nil" do
      item.add_to_recommender.should be_nil
    end
  end

  describe "#delete_from_recommender" do
    it "should delete the item from the recommender" do
      recommender.should_receive(:delete_item).with(item)
      item.delete_from_recommender
    end

    it "should return nil" do
      item.delete_from_recommender.should be_nil
    end
  end

  describe ".recommended_for" do
    it "should get recommended items from the recommender" do
      recommender.should_receive(:recommended_items).with(user, 10, {"itypes" => ["my_item"] }).and_return []
      MyItem.recommended_for(user, 10)
    end

    context "when there are recommendations" do
      before do
        recommender.stub(:recommended_items).and_return [item.pio_iid]
      end

      it "should return the recommended items" do
        MyItem.recommended_for(user, 1).should == [item]
      end
    end

    context "when there are no recommendations" do
      before do
        recommender.stub(:recommended_items).and_return []
      end

      it "should return an empty array" do
        MyItem.recommended_for(user, 1).should == []
      end
    end
  end

  describe ".similar_to" do
    let(:similar_item) { MyItem.new(:id => 1) }

    it "should get similar items from the recommender" do
      recommender.should_receive(:similar_items).with(item, 10, {"pio_itypes"=>["my_item"]}).and_return []
      MyItem.similar_to(item, 10)
    end

    context "when there are similar items" do
      before do
        recommender.stub(:similar_items).and_return [similar_item.pio_iid]
      end

      it "should return the similar items" do
        MyItem.similar_to(item, 10).should == [similar_item]
      end
    end

    context "when there are no similar items" do
      before do
        recommender.stub(:similar_items).and_return []
      end

      it "should an empty array" do
        MyItem.similar_to(item, 10).should == []
      end
    end
  end
end
