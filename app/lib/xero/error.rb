module Xero
  class Error < StandardError
    XOAuth = Xeroizer::OAuth

    ERRORS = {
      OpenSSL::PKey::RSAError => "Private key is invalid",
      OpenSSL::OpenSSLError => 'Error establishing secure connection to Xero',
      XOAuth::RateLimitExceeded => 'Rate limit exceeded: %{message}',
      XOAuth::ConsumerKeyUnknown => "Consumer key is incorrect",
      XOAuth::UnknownError => "Private key is invalid (%{message})",
      XOAuth::TokenInvalid => "Consumer key is invalid (%{message}).",
      XOAuth::TokenExpired => "Consumer key is invalid (%{message}).",
      Xeroizer::ApiException => '%{message}',
    }.freeze

    def self.wrap
      yield
    rescue *ERRORS.keys => error
      Rails.logger.error "[Xero API Error] #{error.inspect}"
      raise self, error, caller(2)
    end

    def message
      if cause
        format message_template, message: cause.message
      else
        super
      end
    end

   private

    def type_key
      @type_key ||= ERRORS.keys.find { |k| cause.is_a?(k) }
    end

    def message_template
      ERRORS[type_key] || '%{message}'
    end

  end
end
