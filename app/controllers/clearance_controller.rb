class ClearanceController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
    @clearance_items = Item.where(
      status: 'clearanced'
    ).includes(:style).order(clearanced_at: :desc).limit 25 
  end


end
