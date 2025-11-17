class NestedComplexPersonInput < NestedAttributesInput

  protected

  def build_components(attribute_name, value, index, options, parent=@builder.object_name)
    out = ''
    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:complex_person) and index == 0
      required = true
    end

    # Add remove element only if element repeats
    repeats = options.delete(:repeats)
    repeats = true if repeats.nil?

    parent_attribute = name_for(attribute_name, index, '', parent)[0..-5]

    # --- first_name
    field = :first_name
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)

    field_value = value.blank? ? '' : value[field]

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, I18n.t('app.fields.first_name'), required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
                               options.merge(value: field_value, name: field_name, id: field_id, required: required, placeholder: "Alphabets"))
    out << '  </div>'
    out << '</div>' # row

    # --- last_name
    field = :last_name
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.blank? ? '' : value[field]

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, I18n.t('app.fields.last_name'), required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
                               options.merge(value: field_value, name: field_name, id: field_id, required: required, placeholder: "Alphabets"))
    out << '  </div>'
    out << '</div>' # row

    # --- role
    role_options = ::RoleService.new.select_all_options
    field = :role
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.blank? ? '' : value[field]

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << template.select_tag(field_name, template.options_for_select(role_options, field_value || 'creator'),
        prompt: 'Select role played', label: '', class: 'select form-control', id: field_id, required: required)
    out << '  </div>'
    out << '</div>' # row

    # --- orcid
    field = :orcid
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.blank? ? '' : value[field]

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: false)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false, placeholder: "https://orcid.org/0000-0000-0000-0000"))
    out << '  </div>'
    out << '</div>' # row

    # --- affiliation
    field = :affiliation
    field_name = name_for(attribute_name, index, field, parent)
    field_id = id_for(attribute_name, index, field, parent)
    field_value = value.blank? ? '' : value[field]

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: false)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
                               options.merge(value: field_value, name: field_name, id: field_id, required: false, placeholder: "affiliation"))
    out << '  </div>'
    out << '</div>' # row

    if repeats == true
      field_label = 'Person'
      out << "<div class='row'>"
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label, parent)
      out << '  </div>'
      out << '</div>' # last row
    end

    out
  end
end
