require 'rails_helper'


describe "ItemManager" do
  let(:item) {
    FactoryGirl.create(
      :item, style: FactoryGirl.create(:cheap_pants)  
    )
  } 


  it "should not initialize without an event" do
    expect {
      ItemManager.new
    }.to raise_error "Event argument required"
  end 

  it "should not initialize without a valid event" do
    expect {
      ItemManager.new(event: "list")
    }.to raise_error "Invalid event"
  end 

  it "should receive item_id arg if event is in the event list" do
    expect {
      ItemManager.new(event: "unclearance")
    }.to raise_error "Missing required item_id argument to unclearance"
    expect {
      ItemManager.new(event: "clearance")
    }.to raise_error "Missing required item_id argument to clearance"
  end
 
  it "should not initiate if item is not found" do 
    expect { 
      ItemManager.new(item_id: 999, event: 'clearance') 
    }.to raise_error
  end

  describe "#process_event" do
    it "should perform clearance method for the instance" do
      im = ItemManager.new(item_id: item.id, event: "clearance")
      im.process_event
      item.reload
      expect(item.status).to eq("clearanced")
    end

    it "should perform the unclearance method for the instance" do
      clearance_event = ItemManager.new(item_id: item.id, event: "clearance")
      clearance_event.process_event
      item.reload
      im = ItemManager.new(item_id: item.id, event: "unclearance")
      im.process_event
      item.reload
      expect( item.clearanced_at ).to eq(nil)
    end
  end

end
