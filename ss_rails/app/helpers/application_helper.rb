module ApplicationHelper
  

  
  def build_producer_select
    producers = @producer_class.where(:owner_id => displayed_taster.id)
    producers.collect { |producer| [producer.name, producer.id] }
  end
  
  def build_product_select
    products = @product_class.where(:owner_id => displayed_taster.id)
    products.collect { |product| [product.name, product.id] }
  end
  
end
