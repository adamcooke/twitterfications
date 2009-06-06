module Twitterfications
  module ActionControllerExtensions
    
    protected
    
    def tweet(status)
      Twitterfications.post(status)
    end
    
  end
end

ActionController::Base.send :include, Twitterfications::ActionControllerExtensions
