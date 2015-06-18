require 'rails_helper'

describe Item do
  describe "#perform_clearance!" do

    let(:wholesale_price) { 100 }
    let(:shiny_pants_ws_price) { 100 }
    let(:cheap_pants_ws_price) { 6 }
    let(:item) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(
          :style, 
          name: "Normal Pants", 
          type: 'Pants', 
          wholesale_price: wholesale_price)
      ) 
    }
    
    let(:cheap_pants) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(:cheap_pants)
      ) 
    }
    let(:shiny_pants) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(:shiny_pants)
      ) 
    }
    
    let(:cheap_dress) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(:cheap_dress)
      ) 
    }
    let(:shiny_dress) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(:shiny_dress)
      ) 
    }
    let(:cheap_top) { 
      FactoryGirl.create(
        :item, 
        style: FactoryGirl.create(:cheap_top)
      ) 
    }
    
    before do
      item.clearance!
      item.reload
    end
    
    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end

    it "should set the item's clearanced_at value" do
      expect(item.clearanced_at).to_not eq(nil)
    end
    
    it "should set the price_sold as 75% of the wholesale_price" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end

    context "dresses and pants vs other types" do
    
      it "should not set clearance pants price sold to a price less than 5 dollars" do
        cheap_pants.clearance!
        cheap_pants.reload
        expect(cheap_pants.price_sold).to be >= 5
        shiny_pants.clearance!
        shiny_pants.reload
        expect(shiny_pants.price_sold).to be >= 5
      end
    
      it "should not set clearance dresses price sold to a price less than 5 dollars" do
        cheap_dress.clearance!
        cheap_dress.reload
        expect(cheap_dress.price_sold).to be >= 5
        shiny_dress.clearance!
        shiny_dress.reload
        expect(shiny_dress.price_sold).to be >= 5
      end

      it "should not set clearance items with low wholesale price to a price less than 2 dollars" do
        cheap_top.clearance!
        cheap_top.reload
        expect(cheap_top.price_sold).to be >= 2
      end
    end 
  end
end
