module ContactsHelper
  def formatted_value(value)
    return value unless value.is_a? Array

    content_tag(:ol) do
      safe_join value.map { |v| content_tag(:li, formatted_value(v)) }
    end
  end
end
