class NestedAttributesInput < MultiValueInput

  def input(wrapper_options)
    super
  end

  protected

  def build_field(value, index, parent=@builder.object_name)
    @rendered_first_element = false
    options = input_html_options.dup
    
    options[:name] = name_for(attribute_name, index, 'hidden_label'.freeze, parent)
    options[:id] = id_for(attribute_name, index, 'hidden_label'.freeze, parent)
    
    if new_record?(value)
      build_options_for_new_row(attribute_name, index, options)
    else
      build_options_for_existing_row(attribute_name, index, value, options)
    end
    # end

    options[:required] = nil if @rendered_first_element

    options[:class] ||= []
    options[:class] += ["#{} form-control multi_value multi-text-field"]
    options[:'aria-labelledby'] = label_id
    out = ''

    if false#value.is_a?(Array)
      value.each do |val|
        out << build_components(attribute_name, val, index, options, parent)
        #out << hidden_id_field(value, index, parent) unless new_record?(value)
      end
    else
      out << build_components(attribute_name, value, index, options, parent)
    end
    out

    @rendered_first_element = true
    out
  end

  def destroy_widget(attribute_name, index, field_label="field", parent=@builder.object_name)
    out = ''
    out << hidden_destroy_field(attribute_name, index, parent)
    out << "    <button type=\"button\" class=\"btn btn-link remove\">"
    out << "      <span class=\"glyphicon glyphicon-remove\"></span>"
    out << "      <span class=\"controls-remove-text\">Remove</span>"
    out << "      <span class=\"sr-only\"> previous <span class=\"controls-field-name-text\"> #{field_label}</span></span>"
    out << "    </button>"
    out
  end

  def hidden_id_field(value, index, parent=@builder.object_name)
    name = id_name_for(attribute_name, index, parent)
    id = id_for(attribute_name, index, 'id'.freeze, parent)
    hidden_value = new_record?(value) ? '' : value.rdf_subject
    @builder.hidden_field(attribute_name, name: name, id: id, value: hidden_value, data: { id: 'remote' })
  end

  def hidden_destroy_field(attribute_name, index, parent=@builder.object_name)
    name = destroy_name_for(attribute_name, index, parent)
    id = id_for(attribute_name, index, '_destroy'.freeze, parent)
    hidden_value = false
    @builder.hidden_field(attribute_name, name: name, id: id,
      value: hidden_value, data: { destroy: true }, class: 'form-control remove-hidden')
  end

  def build_options_for_new_row(_attribute_name, _index, options)
    options[:value] = ''
  end

  def build_options_for_existing_row(_attribute_name, _index, value, options)
    options[:value] = '' #value.rdf_label.first || "Unable to fetch label for #{value.rdf_subject}"
  end

  def name_for(attribute_name, index, field, parent=@builder.object_name)
    "#{parent}[#{attribute_name}_attributes][#{index}][#{field}][]"
  end

  def id_name_for(attribute_name, index, parent=@builder.object_name)
    singular_input_name_for(attribute_name, index, 'id', parent)
  end

  def destroy_name_for(attribute_name, index, parent=@builder.object_name)
    singular_input_name_for(attribute_name, index, '_destroy', parent)
  end

  def singular_input_name_for(attribute_name, index, field, parent=@builder.object_name)
    "#{parent}[#{attribute_name}_attributes][#{index}][#{field}]"
  end

  def id_for(attribute_name, index, field, parent=@builder.object_name)
    [parent, "#{attribute_name}_attributes", index, field].join('_'.freeze)
  end

  def value_is_empty?(value)
    is_empty = true
    value.each do |t|
      if (t.predicate.start_with?('http://www.example.com') or
        t.predicate.start_with?('http://www.hyrax-example.com')) and t.object.present?
        is_empty = false
      end
    end
    is_empty
  end

  def new_record?(hash)
    return true if hash.blank?
    hash.values.all?(&:blank?)
  end

  def name_for(attribute_name, index, field, parent)
    "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}]"
  end

  def collection
    @collection ||=
      if attribute_name == :complex_person
        Array(object.send(attribute_name)).reject { |v| v.to_s.strip.blank? }.sort_by { |v| v[:display_order].present? ? v[:display_order].to_i : 500 } + ['']
      else
        Array(object.send(attribute_name)).reject { |v| v.to_s.strip.blank? } + ['']
      end
  end
end
