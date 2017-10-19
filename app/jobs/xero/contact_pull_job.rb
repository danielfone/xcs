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

    def api_client
      Xero::Client.new.api_client
    end
  end
end
