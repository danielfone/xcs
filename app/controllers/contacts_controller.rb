class ContactsController < ApplicationController

  def index
    @contacts = Xero::Contact.all
  end

end
