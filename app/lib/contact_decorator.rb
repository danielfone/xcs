class ContactDecorator < SimpleDelegator
  attr_reader :view_context
  alias_method :v, :view_context

  DEEP_LINK_URL = "https://go.xero.com/organisationlogin/default.aspx?" \
    "shortcode=%<shortcode>s&" \
    "redirecturl=%<target_url>s"

  def initialize(contact, view:)
    super(contact)
    @view_context = view
  end

  def xero_link
    external_link_to(name, xero_url)
  end

  # https://developer.xero.com/documentation/api-guides/deep-link-xero
  def xero_url
    target = "/Contacts/View.aspx?contactID=#{id}"
    format(DEEP_LINK_URL, shortcode: org_code, target_url: target)
  end

  def outstanding
    v.number_to_currency data.dig('balances', 'accounts_receivable', 'outstanding')
  end

  def formatted_data
    data.transform_values(&method(:format_data))
  end

private

  def external_link_to(name = nil, options = nil, html_options={})
    v.link_to options, html_options.merge(target: '_blank') do
      v.safe_join [
        name,
        v.content_tag(:sup, nil, class: "fa fa-external-link", 'aria-hidden' => "true")
      ], ' '
    end
  end


  def format_data(value)
    case value
    when Array
      v.content_tag(:ol) do
        v.safe_join value.map { |e| v.content_tag(:li, format_data(e)) }
      end
    else
      value
    end
  end

end
