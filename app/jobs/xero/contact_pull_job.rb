module Xero
  class ContactPullJob < ApplicationJob

    def perform
      Error.wrap { Contact.upsert_api_response(api_results) }
      # I wish we could just add the org code to each record
      # as we were saving it…
      Contact.update_all org_code: org_code
    end

  private

    def org_code
      @org_code ||= api_client.Organisation.first.short_code
    end

    def api_results
      api_client.Contact.all(modified_since: Contact.last_updated_at)
    end

    def api_client
      @api_client ||= Xeroizer::PrivateApplication.new(
        secrets[:consumer_key],
        secrets[:consumer_secret],
        nil,
        private_key: secrets[:private_key],
      )
    end

    def secrets
      Rails.application.secrets[:xero]
    end
  end
end
