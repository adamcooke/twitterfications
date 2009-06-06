module Twitterfications
  class Twitter
    
    cattr_accessor :username, :password, :site
    
    class MissingConfig < RuntimeError; end
    
    def initialize
      ## Define where twitter is...
      @@site = "http://twitter.com" if @@site.blank?
      
      ## Make sure the user has actually configured a username and password for the application. Create
      ## config/initializer/twitterfications.rb and add the following:
      ##
      ##   Twitterfications::Twitter.username = 'my_username'
      ##   Twitterfications::Twitter.password = 'my_password'
      
      if @@username.blank? || @@password.blank?
        raise MissingConfig, "You have not configured your application. Please see the README for details."
      end
    end
    
    
    def post(status)
      deliver('/statuses/update.xml', {:status => status})
    end
    
    
    private
    
    def deliver(path, params = {})
      uri = URI.parse([@@site, path].join)
      http_request = Net::HTTP::Post.new(uri.path)
      http_request.basic_auth @@username, @@password
      http_request.set_form_data(params)
      http_result = Net::HTTP.new(uri.host, uri.port)
      Timeout::timeout(10) do
        http_result = http_result.request(http_request)
      end
      
      case http_result
      when Net::HTTPSuccess
        return true
      else
        return false
      end
    rescue Timeout::Error, SocketError
      return false
    end

  end
end
