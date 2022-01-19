class OmniAuth::Strategies::OAuth2
  def callback_phase # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
    error = request.params["error_reason"] || request.params["error"]
    if error
      fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
    elsif !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
      fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
    else
      self.access_token = build_access_token
      fail!(:token_expired, CallbackError.new(:token_expired,'Token has expired, refresh and try again.')) if access_token.expired?
      super
    end
  rescue ::OAuth2::Error, CallbackError => e
    fail!(:invalid_credentials, e)
  rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
    fail!(:timeout, e)
  rescue ::SocketError => e
    fail!(:failed_to_connect, e)
  end

  def callback_url
    full_host + script_name + callback_path
  end
end
