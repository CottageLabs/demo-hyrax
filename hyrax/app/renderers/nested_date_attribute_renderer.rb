class NestedDateAttributeRenderer < NestedAttributeRenderer
  def attribute_value_to_html(input_value)
    html = ''
    return html if input_value.blank?
    value = parse_value(input_value)
    value.each do |v|
      label = 'Date'
      val = ''
      if v.dig('description').present? and v['description'].present?
        label = v['description']
        term = DateService.new.find_by_id(label)
        label = term['label'] if term.any?
      end
      
      if v.dig('date').present? and v['date'].present?
        begin
          val = Date.parse(v['date']).to_formatted_s(:standard)
        rescue ArgumentError
          val = v['date']
        end
      end
      html += get_row(label, val)
    end
    html_out = get_ouput_html(html)
    %(#{html_out})
  end
end
