class Item < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }
  
  def clearance!
    update_attributes!(
      status: 'clearanced', 
      price_sold: clearance_price,
      clearanced_at: Time.zone.now
    )
  end

  def unclearance!
    update_attributes!(
      status: 'sellable',
      price_sold: nil,
      clearanced_at: nil,
      clearance_batch_id: nil
    )
  end  
  
  def clearance_price
    test_price = style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    if ['pants', 'dress'].include?(style.type.downcase)
      test_price = test_price < 5 ? 5 : test_price
    else
      test_price = test_price < 2 ? 2 : test_price
    end
    test_price
  end


  def as_json
   {
      name: truncate(style.name),
      size: size,
      id: id,
      type: style.type,
      url: "/items/#{id}",
      color: color,
      clearance_price: number_to_currency(price_sold),
      clearance_batch_id: clearance_batch_id.nil? ? "SCANNER" : clearance_batch_id,
      clearanced_at: clearanced_at
   }
  end
end
