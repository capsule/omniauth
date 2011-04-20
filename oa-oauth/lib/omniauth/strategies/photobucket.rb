require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    # 
    # Authenticate to Photobucket via OAuth and retrieve basic
    # user information.
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::Photobucket, 'api_key', 'private_key'
    #
    class Photobucket < OmniAuth::Strategies::OAuth
      # Initialize the middleware
      def initialize(app, api_key = nil, private_key = nil, options = {}, &block)
        client_options = {
          :site => 'http://api.photobucket.com',
          :request_token_path => '/login/request',
          :authorize_path => '/apilogin/login',
          :access_token_path => '/login/access'
        }
        
        super(app, :photobucket, api_key, private_key, client_options, options)
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => @access_token.params[:user_id],
          'user_info' => user_info,
          'extra' => {'user_hash' => user_hash}
        })
      end
      
      def user_info
        user_hash = self.user_hash
        
        {
          'username' => user_hash['identifier'],
          'firstname' => user_hash['firstname'],
          'last_name' => user_hash['lastname'],
          'email' => user_hash['email']
        }
      end
      
      def user_hash
      end
    end
  end
end
