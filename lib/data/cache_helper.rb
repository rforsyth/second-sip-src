
module Data::CacheHelper
  
  def fetch_producer_name(id)
    @producer_name_store[id]
  end
	
	def fetch_product(id)
	  fetch_helper(@product_store, @product_class, id)
	end
	def fetch_producer(id)
	  fetch_helper(@producer_store, @producer_class, id)
	end
	def fetch_taster(id)
	  fetch_helper(@taster_store, Taster, id)
	end
	def fetch_tag(id)
	  fetch_helper(@tag_store, Tag, id)
	end
	def fetch_admin_tag(id)
	  fetch_helper(@admin_tag_store, AdminTag, tag_id)
	end
	
	def store_taster(taster)
	  @taster_store ||= {}
	  @taster_store[taster.id] = taster
	end
	
	def store_producer(producer)
	  @producer_store ||= {}
	  @producer_store[producer.id] = producer
	end
	
	def store_product(product)
	  @product_store ||= {}
	  @product_store[product.id] = product
	end
	
	def store_owners(beverages)
    @taster_store ||= {}
	  store_association_helper(@taster_store, Taster, beverages, 'owner_id')
  end
	
	def store_note_products(notes)
    @product_store ||= {}
	  store_association_helper(@product_store, @product_class, notes, 'product_id')
  end
	
	def store_note_products_and_producers(notes)
    @product_store ||= {}
    @producer_store ||= {}
	  store_association_helper(@product_store, @product_class, notes, 'product_id')
	  store_association_helper(@producer_store, @producer_class, product_store, 'producer_id')
	  return @product_store
  end
  
  def store_product_producers(products)
    @producer_store ||= {}
	  store_association_helper(@producer_store, @producer_class, products, 'producer_id')
	  
	  @producer_name_store ||= {}
	  @producer_store.each_value do |producer|
	    @producer_name_store[producer.id] = producer.name
	  end
  end
  
  private
  
	def fetch_helper(store, model, object_id)
	  if store.present? && store.has_key?(object_id)
	    return store[object_id]
	  end
	  Rails.cache.fetch(format_cache_key(model, object_id)) do
	    model.find(object_id)
	  end
	end
	
	def store_association_helper(store, model, objects, foreign_key_name)
	  ids_to_read = []
	  objects.each do |object|
	    foreign_key = object.send(foreign_key_name)
	    if !store.has_key?(foreign_key) && !ids_to_read.include?(foreign_key)
        if cached_object = Rails.cache.read(format_cache_key(model, foreign_key))
          store[foreign_key] = cached_object
        else
          ids_to_read << foreign_key
        end
      end
    end
    
    if ids_to_read.present?
      objects = model.find(ids_to_read)
      objects.each do |object|
        store[object.id] = object
        Rails.cache.write(format_cache_key(model, object.id), object)
      end
    end
    return store
  end
  
  def format_cache_key(model, id)
    "#{model.name.underscore}_#{id}"
  end

end