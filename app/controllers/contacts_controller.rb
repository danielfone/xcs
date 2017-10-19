class ContactsController < ApplicationController

  helper_method :external_link_to

  def index
    @contacts = Xero::Contact.all.order(:name)
  end

  def perform
    sync!
    flash_success
    redirect(:index)

  rescue Xero::Error => error
    flash_error(error)
    redirect(:root)
  end

private

  def sync!
    Xero::ContactPullJob.perform_now
  end

  def flash_success
    flash[:success] = "Updated contacts from Xero"
  end

  def flash_error(error)
    flash[:error] = "[Xero Error] #{error.message}"
  end

  def redirect(fallback_location)
    redirect_back fallback_location: fallback_location
  end

  def external_link_to(name = nil, options = nil, html_options={})
    view_context.link_to options, html_options.merge(target: '_blank') do
      view_context.safe_join [
        name,
        view_context.content_tag(:sup, nil, class: "fa fa-external-link", 'aria-hidden' => "true")
      ], ' '
    end
  end
end
