require 'rubygems'
require 'httparty'

class Dezutes
  include HTTParty
  
  base_uri 'http://api.dezutes.lt/v1'
  
  def initialize(subdomain, api_key)
    @auth = {:username => subdomain, :password => api_key}
  end

  def estates(*args)
    send_request("/estates", *args)
  end
  
  def estate(id, *args)
    send_request("/estate/#{id}", *args)
  end
  
  def estate_photos(id, *args)
    send_request("/estates/#{id}/photos", *args);
  end
  
  def estate_count(*args)
    send_request("/estates_count", *args)
  end
  
  def gestate_municipalities(*args)
    send_request("/municipalities", *args)
  end
  
  def estate_cities(*args)
    send_request("/cities", *args)
  end
  
  def estate_blocks(*args)
    send_request("/blocks", *args)
  end
  
  def projects(*args)
    send_request("/projects", *args)
  end
  
  def project(id, *args)
    send_request("/projects/#{id}", *args)
  end
  
  def project_photos(id, *args)
    send_request("/projects/#{id}/photos", *args)
  end
  
  def project_estates(id, *args)
    send_request("/projects/#{id}/estates", *args)
  end
  
  protected
  def send_request(resource_location, *args)
    response_type = args.first.is_a?(Symbol) ? args.shift : :xml
    options = (args.last.is_a?(Hash) ? args.pop : {}).merge!(
    {
      :basic_auth => @auth
    })
    self.class.get(resource_location.concat(".#{response_type}"), options)
  end
  
end