module Xero
  class ContactPullJob < ApplicationJob

    def perform
      Contact.upsert_api_response(api_results, org_code)
    end

    def fetched_results
      api_results.size
    end

  private

    # https://developer.xero.com/documentation/api/organisation
    def org_code
      @org_code ||= api_client.Organisation.first.short_code
    end

    def api_results
      Error.wrap do
        # https://developer.xero.com/documentation/api/contacts
        @api_results ||= api_client.Contact.all(
          modified_since: Contact.last_updated_at,
          include_archived: true,
        )
      end
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
