class ContactsController < ApplicationController

  helper_method :external_link_to

  def index
    @contacts = Xero::Contact.all.order(:name)
  end

  def sync
    Xero::ContactPullJob.perform_now
    redirect_back fallback_location: :index
  end

private

  def external_link_to(name = nil, options = nil, html_options={})
    view_context.link_to options, html_options.merge(target: '_blank') do
      name
    end
  end

end
