class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end
  
  def show
    alert_message = "No report found"
    begin
      @clearance_batch = ClearanceBatch.find params[:id]
    rescue
      flash[:alert] = alert_message
      redirect_to root_path and return
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@clearance_batch.items)
        send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
      end
    end
  end

  def create
    clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to root_path
  end

  def destroy
    begin  
      @clearance_batch = ClearanceBatch.find params[:id]
      @clearance_batch.items.each do |i|
        im = ItemManager.new(item_id: i.id, event: "unclearance")
        im.process_event
      end
      @clearance_batch.destroy
    rescue e
      render json: {message: "FAIL"}, status: 401 
      raise e and return
    end
    render json: {message: "SUCCESS"}, status: 200
  end
end
