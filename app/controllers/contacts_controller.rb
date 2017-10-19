class ContactsController < ApplicationController

  helper_method :external_link_to

  rescue_from Xero::Error, with: :render_xero_error

  def index
    @contacts = Xero::Contact.order(:name)
  end

  def sync
    Xero::ContactPullJob.perform_now
    flash[:success] = "Updated contacts from Xero"
    redirect_back fallback_location: :index
  end

private

  def external_link_to(name = nil, options = nil, html_options={})
    view_context.link_to options, html_options.merge(target: '_blank') do
      view_context.safe_join [
        name,
        view_context.content_tag(:sup, nil, class: "fa fa-external-link", 'aria-hidden' => "true")
      ], ' '
    end
  end

  def render_xero_error(error)
    flash[:error] = "[Xero Error] #{error.message}"
    redirect_back fallback_location: :root
  end

end
