require "rails_helper"

describe "clearance one item", js: true do


  let(:shiny_pants) { 
      FactoryGirl.create( 
        :item,
        style: FactoryGirl.create(:shiny_pants)
      )
  }
  describe "clearance_index", type: :feature do
    it "should display the clearance tool" do
      visit "/"
      expect(page).to have_content("Item Clearance Tool")
    end
  end

  describe "clearance by item id" do
    it "should accept a single ID input" do
      visit "/"
      
      within(".clearance_inputs") do
        fill_in "Item ID", with: shiny_pants.id 
      end
      click_button "clearance item"
      sleep 2
      expect(page).to have_content("L. Larry Shiny Pants")
    end
  end
 
  describe "link to item index", js:true do
    it "should show complete index of items" do
          FactoryGirl.create( 
            :item,
            style: FactoryGirl.create(:shiny_pants)
          )
      visit "/"
      click_link("See All Items")
      expect(page).to have_content("L. Larry Shiny Pants")
    end
  end 
end

