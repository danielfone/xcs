module Xero
  class Client
    def api_client
      Xeroizer::PrivateApplication.new(
        secrets[:consumer_key],
        secrets[:consumer_secret],
        nil,
        private_key: secrets[:private_key],
        # logger: Logger.new(STDOUT)
      )
    end

    def secrets
      Rails.application.secrets[:xero]
    end
  end
end
