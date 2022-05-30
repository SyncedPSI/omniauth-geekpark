module OmniAuth
  module Strategies
    class Synced < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://www.jiqizhixin.com/',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }

      uid { raw_info['id'] }

      info do
        {
          username: raw_info['username'],
          nickname: raw_info['name'],
          avatar: raw_info['avatar'],
          email: raw_info['email'],
          mobile: raw_info['mobile'],
          bio: raw_info['bio'],
          pubinfo: raw_info['pubinfo'],
          union_id: raw_info['unionid']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v3/user').parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'synced', 'Synced'
