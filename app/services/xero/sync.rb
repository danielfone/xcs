module Xero
  class Sync
    attr_reader :api_client

    def initialize(api_client)
      @api_client = api_client
    end

    def perform
      upsert_api_response(api_results)
    end

    private

    def api_results
      Error.wrap do
        # https://developer.xero.com/documentation/api/contacts
        @api_results ||= api_client.Contact.all(
          modified_since: Contact.last_updated_at,
          include_archived: true,
        )
      end
    end

    def upsert_api_response(results, *args, &block)
      Contact.transaction do
        Array.wrap(results).each do |result|
          upsert_api_result(result, *args, &block)
        end
      end
    end

    def upsert_api_result(contact)
      # https://github.com/jesjos/active_record_upsert
      Contact.upsert(
        id: contact[:contact_id],
        name: contact[:name],
        status: (contact[:contact_status] || 'ACTIVE'),
        updated_at: contact[:updated_date_utc],
        synced_at: Time.current,
        data: contact.to_h,
        org_code: org_code
      )
    end

    def org_code
      @org_code ||= api_client.Organisation.first.short_code
    end
  end
end
