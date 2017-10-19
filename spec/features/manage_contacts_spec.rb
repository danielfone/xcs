require 'rails_helper'
require 'support/xero_helper'

RSpec.feature 'Manage Xero contacts', type: :feature do
  include XeroHelper
  around { |spec| with_xero_cassette { spec.run } }
  around { |spec| Timecop.freeze('2017-10-10') { spec.run } }

  background do
    visit '/'
  end

  scenario 'A user syncs contacts' do
    expect(page).to have_content 'Showing 0 contacts.'
    expect(page).to have_content 'Never synced'
    click_on 'Sync Now'

    expect(page).to have_content <<-PAGE
      Showing 45 contacts. Last modified: 1 day ago.

      Last synced: less than a minute ago.

      Name      Status Owing
      24 Locks  ACTIVE
        Contact f1d403d1-7d30-46c2-a2be-fc2bb29bd295
        Contact Status ACTIVE
        Name 24 Locks
        Addresses
          {"address_type"=>"POBOX"}{"address_type"=>"STREET"}
        Phones
          {"phone_type"=>"DDI"}{"phone_type"=>"DEFAULT"}{"phone_type"=>"FAX"}{"phone_type"=>"MOBILE"}
        Updated Date Utc 2017-10-08T18:03:42.280Z
        Is Supplier false
        Is Customer false

      7-Eleven (Seven 11)   ACTIVE
        Contact c0a64e06-4d52-4d8c-bbb8-f34eb4089546
        Contact Status ACTIVE
        Name 7-Eleven (Seven 11)
        Addresses
          {"address_type"=>"STREET"}{"address_type"=>"POBOX"}
        Phones
          {"phone_type"=>"DDI"}{"phone_type"=>"DEFAULT"}{"phone_type"=>"FAX"}{"phone_type"=>"MOBILE"}
        Updated Date Utc 2017-10-08T23:10:01.307Z
        Is Supplier false
        Is Customer false

      ABC Furniture   ACTIVE $0.00
        Contact bde095a6-1c01-4e1d-b6f4-9190cfe89a9c
        Contact Status ACTIVE
        Name ABC Furniture
        First Name Trish
        Last Name Rawlings
        Addresses
          {"address_type"=>"STREET"}{"address_type"=>"POBOX"}
        Phones
          {"phone_type"=>"DDI"}{"phone_type"=>"DEFAULT", "phone_number"=>"124578", "phone_area_code"=>"800"}{"phone_type"=>"FAX"}{"phone_type"=>"MOBILE"}
        Updated Date Utc 2017-10-08T18:03:42.297Z
        Is Supplier true
        Is Customer false
        Default Currency NZD
        Balances
          {"accounts_receivable"=>{"outstanding"=>"0.0", "overdue"=>"0.0"}, "accounts_payable"=>{"outstanding"=>"1150.0", "overdue"=>"0.0"}}
    PAGE
    expect(page).to have_link('24 Locks', href: 'https://go.xero.com/organisationlogin/default.aspx?shortcode=!GjVms&redirecturl=/Contacts/View.aspx?contactID=f1d403d1-7d30-46c2-a2be-fc2bb29bd295')
  end

  scenario 'The config is misconfigured' do
    Rails.application.secrets[:xero][:consumer_key] = 'foo'
    click_on 'Sync Now'
    expect(page).to have_content '[Xero Error] Consumer key is incorrect'
  end

end
