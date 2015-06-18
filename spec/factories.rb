FactoryGirl.define do  
  
  factory :clearance_item do
  end


  factory :clearance_batch do

  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
  end

  factory :style do
    type "Pants"
    name "L. Larry Shiny Pants"
    wholesale_price 55
  end
  
  factory :cheap_pants, class: "Style" do
    type "Pants"
    name "L. Larry Cheap Pants"
    wholesale_price 6
  end
  
  factory :shiny_pants, class: "Style"do
    type "Pants"
    name "L. Larry Shiny Pants"
    wholesale_price 10
  end
  factory :cheap_dress, class: "Style" do
    type "Dress"
    name "L. Larry Cheap Dress"
    wholesale_price 6
  end
  factory :shiny_dress, class: "Style" do
    type "Dress"
    name "L. Larry Cheap Dress"
    wholesale_price 10
  end

  factory :normal_top, class: "Style" do
    type "Top"
    name "L. Larry Normal Top"
    wholesale_price 10
  end

  factory :cheap_top, class: "Style" do
    type "Top"
    name "L. Larry Cheap Top"
    wholesale_price 2.20
  end
end
