require 'rails_helper'
require 'support/xero_helper'

RSpec.describe Xero::ContactPullJob do
  include XeroHelper

  subject(:job) { described_class.new }

  around { |spec| with_xero_cassette { spec.run } }

  it 'should fetch only recent updates' do
    contact = create :xero_contact, {
      id: "c0a64e06-4d52-4d8c-bbb8-f34eb4089546",
      name: '7-Eleven',
      synced_at: 1.day.ago,
      updated_at: '2017-10-08T23:00',
    }

    expect { job.perform }.not_to change { Xero::Contact.count }
    contact.reload
    expect(contact.name).to eq "7-Eleven (Seven 11)"
    expect(contact.org_code).to eq "!GjVms"
    expect(contact.synced_at).to be > 1.second.ago
    expect(contact.updated_at).to eq Time.zone.parse('Mon, 9 Oct 2017 12:10:01.307 NZDT +13:00')
  end
end
