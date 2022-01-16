module OmniAuth
  module Strategies
    class WeChatService < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://api.weixin.qq.com',
        authorize_url: 'https://open.weixin.qq.com/connect/oauth2/authorize',
        token_url: 'https://api.weixin.qq.com/sns/oauth2/access_token',
      }

      option :provider_ignores_state, true

      uid { raw_info['unionid'] }

      info do
        {
          nickname: raw_info['nickname'],
          city: raw_info['city'],
          avatar: raw_info['headimgurl'],
          openid: access_token['openid']
        }
      end

      def raw_info
        @raw_info ||= begin
                        response = access_token.get(
                          '/sns/userinfo',
                          { params: { access_token: access_token.token,
                                      openid: access_token['openid'],
                                      lang: 'zh-CN' },
                                      parse: :json }
                        ).parsed
                        log :debug, response
                        response
                      end
      end

      def request_phase
        redirect client.authorize_url(authorize_params)+'#wechat_redirect'
      end

      def authorize_params
        params = options.authorize_params.merge({
          appid: options.client_id,
          redirect_uri: callback_url,
          response_type: 'code',
          state: request.params['state'],
          scope: request.params['scope'] || 'snsapi_userinfo'
        })
        if OmniAuth.config.test_mode
          @env ||= {}
          @env["rack.session"] ||= {}
        end
        unless options.provider_ignores_state
          params[:state] = SecureRandom.hex(24)
          session["omniauth.state"] = params[:state]
        end
        params
      end

      def token_params
        { appid: options.client_id, secret: options.client_secret }
      end

      def callback_phase
        # 其它 app 需要获取微信openid 时,将 callbackurl 传入 state 参数
        if request.params['state'].match(/\Ahttps?:\/\/(.*\.)?geekpark\.net\/.*\z/)
          uri = URI(request.params['state'])
          query = Rack::Utils.parse_nested_query(uri.query).merge(code: request.params['code'])
          uri.query = URI.encode_www_form query
          env['omniauth.redirect'] = uri.to_s
          call_app!
        else
          super
        end
      end

      protected

      def build_access_token
        request_params = {
          appid: options.client_id,
          secret: options.client_secret,
          code: request.params['code'],
          grant_type: 'authorization_code',
          parse: :json
        }
        client.get_token(request_params, {mode: :query})
      end

    end
  end
end

OmniAuth.config.add_camelization('wechatservice', 'WeChatService')
