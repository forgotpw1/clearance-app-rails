class ItemManager

  EVENTS = ["clearance", "unclearance"]
  
  attr_reader :item
 
  def initialize(args = {})
    @event = args[:event]
    raise "Event argument required" if @event.nil?
    @event = @event.downcase
    raise "Invalid event" if !EVENTS.include?(@event)
    if args[:item_id].nil?
      raise "Missing required item_id argument to #{@event.to_s}" 
    end
    @item = Item.find(args[:item_id])
  end
  
  def process_event
    self.__send__(@event.to_sym) 
  end

private

  def clearance
    @item.clearance!
  end
  
  def unclearance
    @item.unclearance!
  end

end
