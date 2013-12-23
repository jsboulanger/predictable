describe Predictable::Recommender do
  let(:client) { double("PredictionIO Client") }
  let(:recommender) { Predictable::Recommender.new(client) }

  let(:item) { double("Item", :pio_iid => "item-123", :pio_itypes => ["item"]) }

  # TODO: item should behave as an item

  describe "#create_item" do
    it "should call the api" do
      client.should_receive(:acreate_item)
        .with("item-123", ["item"], {})
      recommender.create_item(item)
    end
  end

  describe "#delete_item" do
    it "should call the api" do
      client.should_receive(:adelete_item)
        .with("item-123")
      recommender.delete_item(item)
    end
  end

  let(:user) { double("User", :pio_uid => "user-1") }
  # TODO: user should behave as a user

  describe "#create_user" do
    it "should call the api" do
      client.should_receive(:acreate_user)
        .with("user-1", {})
      recommender.create_user(user)
    end
  end

  describe "#delete_user" do
    it "should call the api" do
      client.should_receive(:adelete_user)
        .with("user-1")
      recommender.delete_user(user)
    end
  end

  describe "#record_action" do
    it "should call the api" do
      client.should_receive(:identify).with("user-1")
      client.should_receive(:arecord_action_on_item)
        .with("conversion", "item-123", {})
      recommender.record_action(user, :conversion, item)
    end
  end

  describe "#recommended_items" do
    before do
      client.stub(:identify)
      recommender.recommendation_engine = "itemrec"
    end

    it "should call the api" do
      client.should_receive(:identify).with("user-1")
      client.should_receive(:get_itemrec_top_n)
        .with("itemrec", 10, {})
        .and_return([])
      recommender.recommended_items(user, 10)
    end

    context "when items are found" do
      before do
        client.stub(:get_itemrec_top_n).and_return(["item-1", "item-2"])
      end

      it "should return an array of item ids" do
        recommender.recommended_items(user, 10).should == ["item-1", "item-2"]
      end
    end

    context "when no items are found" do
      before do
        client.stub(:get_itemrec_top_n).and_raise(PredictionIO::Client::ItemRecNotFoundError)
      end

      it "should return an empty array" do
        recommender.recommended_items(user, 10).should == []
      end
    end
  end # recommended_items

  describe "#similar_items" do
    before do
      client.stub(:identify)
      recommender.similarity_engine = "itemsim"
    end

    it "should call the api" do
      client.should_receive(:get_itemsim_top_n)
        .with("itemsim", "item-123", 10, {})
        .and_return([])

      recommender.similar_items(item, 10)
    end

    context "when items are found" do
      before do
        client.stub(:get_itemsim_top_n).and_return(["item-1", "item-2"])
      end

      it "should return an array of item ids" do
        recommender.similar_items(item, 10).should == ["item-1", "item-2"]
      end
    end

    context "when no items are found" do
      before do
        client.stub(:get_itemsim_top_n).and_raise(PredictionIO::Client::ItemSimNotFoundError)
      end

      it "should return an empty array" do
        recommender.similar_items(item, 10).should == []
      end
    end
  end # similar_items
end
