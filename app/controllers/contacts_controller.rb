class ContactsController < ApplicationController

  def index
    @contacts = Xero::Contact.all.order(:name)
  end

end
