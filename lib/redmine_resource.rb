require File.dirname(__FILE__) + '/publishHelper'

# Issue model on the client side
class RedmineResource < ActiveResource::Base
  self.site = "https://redmine.veladan.org"
  # self.proxy = 'http://proxy.sdc.hp.com:8080'
  self.format = :xml
  self.headers['X-Redmine-API-Key'] =  
  			redmineAPIKEY()
end
