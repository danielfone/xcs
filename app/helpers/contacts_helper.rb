module ContactsHelper
  def external_link_to(name = nil, options = nil, html_options={})
    link_to options, html_options.merge(target: '_blank') do
      safe_join [
        name,
        content_tag(:sup, nil, class: "fa fa-external-link", 'aria-hidden' => "true")
      ], ' '
    end
  end

  def formatted_value(value)
    return value unless Array === value

    content_tag(:ol) do
      safe_join value.map { |v| content_tag(:li, formatted_value(v)) }
    end
  end
end
