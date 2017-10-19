module Xero
  class ContactPullJob < ApplicationJob
    def perform
      Xero::Sync.new(api_client).perform
      # I wish we could just add the org code to each record
      # as we were saving it…
      Contact.update_all org_code: org_code
    end

    private

    # https://developer.xero.com/documentation/api/organisation
    def org_code
      @org_code ||= api_client.Organisation.first.short_code
    end

    # https://github.com/waynerobinson/xeroizer
    def api_client
      @api_client ||= Xeroizer::PrivateApplication.new(
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
