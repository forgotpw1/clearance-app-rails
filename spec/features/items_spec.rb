require "rails_helper"

describe "viewing items", js: true do
  describe "default view" do

    
    it "should show no items if there are no items" do
      
      visit("/items")
      expect(page).to have_content("No Items")
    end 
    it "should show items" do
      shiny_pants = FactoryGirl.create( 
        :item,
        style: FactoryGirl.create(:shiny_pants)
      )
      visit("/items")
      puts page.body
      expect(page).to have_content("L. Larry Shiny Pants")
    end
  end
end


