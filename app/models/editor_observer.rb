
# Observer tutorial: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Observer.html
# list of callbacks are here: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Callbacks.html

class EditorObserver < ActiveRecord::Observer
  observe Friendship, Lookup, ReferenceLookup, Note, Producer, Product,
          ReferenceProducer, ReferenceProduct, Resource, Tag, AdminTag

  def before_validation(object)
    taster = current_taster
    if taster.nil?
      taster = Taster.find_by_username("Admin")
      Rails.logger.debug 'Used the admin taster to assign an editor because there was no current_taster'
    end
    
    if object.new_record?
      object.creator = taster
      object.owner = taster if object.respond_to?(:owner)
    end
    object.updater = taster
  end

	private
  
  def current_taster
		return TasterSession.find.try(:record)
  end

end

