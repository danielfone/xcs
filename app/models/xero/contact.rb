module Xero
  class Contact < ApplicationRecord
    DEEP_LINK_URL = "https://go.xero.com/organisationlogin/default.aspx?" \
      "shortcode=%<shortcode>s&" \
      "redirecturl=%<target_url>s"

    scope :active, -> { where status: 'ACTIVE' }

    def self.upsert_api_response(results, *args, &block)
      transaction do
        Array.wrap(results).each do |result|
          upsert_api_result(result, *args, &block)
        end
      end
    end

    def self.upsert_api_result(contact)
      upsert(
        id: contact[:contact_id],
        name: contact[:name],
        status: (contact[:contact_status] || 'ACTIVE'),
        updated_at: (contact[:updated_date_utc] if contact[:updated_date_utc]),
        data: contact.attributes,
      )
    end

    def self.last_updated_at
      maximum(:updated_at)
    end

    def xero_url
      target = "/Contacts/View.aspx?contactID=#{id}"
      format(DEEP_LINK_URL, shortcode: org_code, target_url: target)
    end

  end
end
