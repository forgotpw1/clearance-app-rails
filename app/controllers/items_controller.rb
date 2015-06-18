class ItemsController < ApplicationController

  def index
    @page = params[:page]
    @page ||= 1
    @per_page = params[:per_page]
    @per_page ||= 50
#    @items = Item.all.includes(:style).order("updated_at DESC").group(:clearance_batch_id)
    @items = Item.all.includes(:style).order("updated_at DESC")
    @all_items = @items 
    @items = @items.paginate(page: @page, per_page: @per_page) 
  end

  def update
    begin 
      im = ItemManager.new(item_id: params[:id], event: params[:manage_event])
      im.process_event
    rescue
      render json: { message: "FAIL"}, status: 403 and return
    end
    render json: im.item.reload.as_json, status: 200 
  end
end
