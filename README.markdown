Twitterfications
==================

**Twitterfications** allows you to easily setup twitter notifications from your Rails application.

    script/plugin install git://github.com/adamcooke/twitterfications.git

Once installed, simply configure by adding the config below to `config/initializer/twitterfications.rb`

    Twitterfications.method = :direct
    Twitterfications::Twitter.username = 'my_username'
    Twitterfications::Twitter.password = 'my_password'

The method can be set to :direct or :background. Direct requests are sent in the current thread where as 
:background are forked into another process. To use :background, you will need to install the Spawn plugin
from [http://github.com/tra/spawn](http://github.com/tra/spawn)

    script/plugin install git://github.com/tra/spawn

ActiveRecord Usage
------------------
This plugin can be directly embedded with your ActiveRecord models.

    class Person < ActiveRecord::Base
      
      ## Automatically update twitter on create, update, destroy or save
      tweet(:create)    { |p| "#{p.full_name} has been created in the application"}
      tweet(:destroy)   { |p| "#{p.full_name} has been removed from the application"}
      tweet(:update)    { |p| "#{p.full_name} has been updated in the application"}
      
      ## Alternatively, include twitter notifications in your own callbacks
      after_create :my_callback
      
      private
      
      def my_callback
        tweet "This is a tweet about #{self.full_name} from my own callback"
      end
    end

ActionController Usage
------------------
You can also use the `tweet(status)` method in any of your controller actions.

Direct usage
------------------
If you'd like to tweet from anywhere else in your application, you can post directly, by
calling:

    Twitterfications.post("Your tweet here")
  