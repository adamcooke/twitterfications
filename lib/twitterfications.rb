require 'uri'
require 'net/http'

require 'twitterfications/active_record_extensions'
require 'twitterfications/action_controller_extensions'

module Twitterfications
  
  mattr_accessor :method
  
  def self.post(status)
    if @@method == :background
      extend Spawn
      spawn do
        Twitter.post(status)
      end
    else
      Twitter.post(status)
    end
  end
    
end
