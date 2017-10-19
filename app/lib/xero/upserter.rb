module Xero
  class Upserter

    attr_accessor :contact_class, :org_code, :results

    def initialize(contact_class: Contact, results:, org_code:)
      self.contact_class = contact_class
      self.results = results
      self.org_code = org_code
    end

    def upsert_api_response
      contact_class.transaction do
        Array.wrap(results).each do |result|
          upsert_api_result(result)
        end
      end
    end

    def upsert_api_result(contact)
      # https://github.com/jesjos/active_record_upsert
      contact_class.upsert(
        id: contact[:contact_id],
        name: contact[:name],
        status: (contact[:contact_status] || 'ACTIVE'),
        updated_at: contact[:updated_date_utc],
        synced_at: Time.current,
        data: contact.to_h,
        org_code: org_code
      )
    end
  end
end
