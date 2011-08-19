
# Observer tutorial: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Observer.html
# list of callbacks are here: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Callbacks.html

class EditorObserver < ActiveRecord::Observer
  observe Friendship, Lookup, ReferenceLookup, Note, Producer, Product,
          ReferenceProducer, ReferenceProduct, Resource, Tag, AdminTag, Taster

  def before_validation(object)
    if object.new_record?
      object.creator = current_taster
      object.owner = current_taster if object.respond_to?(:owner)
    end
    object.updater = current_taster
  end

	private
  
  def current_taster
		return TasterSession.find.try(:record)
  end

end

