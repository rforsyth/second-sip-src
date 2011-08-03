
# Observer tutorial: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Observer.html
# list of callbacks are here: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Callbacks.html

class EditorObserver < ActiveRecord::Observer
  observe Friendship, Lookup, Note, Producer, Product, Resource, Tag, Taster

  def before_validation(object)
    object.creator = current_taster if object.new_record?
    object.updater = current_taster
  end

	private
  
  def current_taster
		return TasterSession.find.try(:record)
  end

end

