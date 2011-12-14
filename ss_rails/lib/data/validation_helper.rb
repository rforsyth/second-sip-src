

module Data::ValidationHelper
  
  def add_protocol_to_website_url
    return if !self.website_url.present?
    if !(self.website_url.match(/^http:\/\//) || self.website_url.match(/^https:\/\//))
      self.website_url = "http://" + self.website_url
    end
  end

end