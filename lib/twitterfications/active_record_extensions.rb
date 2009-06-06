module Twitterfications
  module ActiveRecordExtensions
    
    module ClassMethods
      
      def tweet(callback, &block)
        write_inheritable_array(:twitterfications, []) unless read_inheritable_attribute(:twitterfications)
        read_inheritable_attribute(:twitterfications) << {:callback => callback, :block => block}
      end
      
    end
    
    module InstanceMethods
      
      def tweet(status)
        Twitterfications.post(status)
      end
      
      private
      
      def deliver_twitterfications(callback)
        callbacks = [callback]
        callbacks << :save if [:create, :update].include?(callback)
        twitterfications = self.class.read_inheritable_attribute(:twitterfications).select{|t| callbacks.include?(t[:callback])}
        twitterfications.each {|t| self.tweet(t[:block].call(self))}
      end
      
      def deliver_twitterfications_on_create
        deliver_twitterfications(:create)
      end
      
      def deliver_twitterfications_on_update
        deliver_twitterfications(:update)
      end
      
      def deliver_twitterfications_on_destroy
        deliver_twitterfications(:destroy)
      end
      
    end
    
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      base.after_create :deliver_twitterfications_on_create
      base.after_update :deliver_twitterfications_on_update
      base.after_destroy :deliver_twitterfications_on_destroy
    end
    
  end
end

ActiveRecord::Base.send :include, Twitterfications::ActiveRecordExtensions
