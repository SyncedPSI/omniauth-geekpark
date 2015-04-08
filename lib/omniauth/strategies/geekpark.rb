require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class GeekPark < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'http://www.geekpark.net',
        authorize_url: 'http://www.geekpark.net/oauth2/authorize',
        token_url: 'http://www.geekpark.net/oauth2/token'
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'username' => raw_info['username'],
          'realname' => raw_info['realname'],
          'email' => raw_info['email'],
          'company' => raw_info['company'],
          'position' => raw_info['position'],
          'mobile' => raw_info['mobile'],
          'avatar' => raw_info['avatar']['url'],
          'bio' => raw_info['bio'],
        }
      end

      def raw_info
        @raw_info ||= access_token.user.as_json({only: [:id, :username, :realname, :email, :avatar, :company, :position, :mobile, :bio]})
      end
    end
  end
end

OmniAuth.config.add_camelization 'geekpark', 'GeekPark'