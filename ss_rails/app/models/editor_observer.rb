
# Observer tutorial: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Observer.html
# list of callbacks are here: http://bryanhinton.com/docs/ruby-on-rails/api/classes/ActiveRecord/Callbacks.html

class EditorObserver < ActiveRecord::Observer
  observe Friendship, Lookup, Note, Producer, Product, Resource, Tag, User



  def before_validation(object)
    object.creator = current_user if object.new_record?
    object.updater = current_user
  end

	private
  
  def current_user
		return UserSession.find.try(:record)
  end

end

