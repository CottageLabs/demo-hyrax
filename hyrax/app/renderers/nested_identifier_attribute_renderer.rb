class NestedIdentifierAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      scheme = 'Identifier'
      val = ''
      unless v.dig('scheme').blank?
        term = ::IdentifierService.new.find_by_id(v['scheme'])
        scheme = term['label'] if term.any?
      end

      unless v.dig('identifier').blank?
        val = v['identifier']
      end
      
      html += get_row(scheme, val)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
