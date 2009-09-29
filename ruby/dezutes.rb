require 'rubygems'
require 'httparty'

class Dezutes
  include HTTParty
  
  base_uri 'http://api.dezutes.lt/v1'
  
  def initialize(subdomain, api_key)
    @auth = {:username => subdomain, :password => api_key}
  end

  def estates(*args)
    response_type = args.first.is_a?(Symbol) ? args.shift : :json
    options = (args.last.is_a?(Hash) ? args.pop : {}).merge!(
    {
      :basic_auth => @auth
    })
    self.class.get("/estates.#{response_type}", options)
  end
  
  def estate(id, *args)
    response_type = args.first.is_a?(Symbol) ? args.shift : :json
    options = (args.last.is_a?(Hash) ? args.pop : {}).merge!(
    {
      :basic_auth => @auth
    })    
    self.class.get("/estate/#{id}.#{response_type}", options)
  end
  
end