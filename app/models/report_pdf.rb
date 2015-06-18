require 'prawn/table' 
class ReportPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(products)
    super()
    @products = products
    @sum = products.each.sum { |i| i.price_sold }
    header
    text_content
    table_content
  end
 
  def header
    
  end
 
  def text_content
    y_position = cursor - 50
 
    bounding_box([0, y_position], :width => 500, :height => 20) do
      text "Clearance Batch ##{@products.first.clearance_batch_id} Report #{Time.zone.now.to_date}", size: 15, style: :bold
    end
 
 
  end
 
  def table_content
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
  end
 
  def product_rows
    rows = [['Style','#', 'Name', 'Color', 'Size', 'Price']] +
      @products.map do |product|
      [product.style.type, product.id, product.style.name, product.color, product.size, number_to_currency(product.price_sold)]
    end
    rows << ["Totals","","","","",number_to_currency(@sum)]
    rows
  end
end
