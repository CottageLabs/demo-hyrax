# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Dataset`
#
# @see https://github.com/samvera/hyrax/wiki/Hyrax-Valkyrie-Usage-Guide#forms
# @see https://github.com/samvera/valkyrie/wiki/ChangeSets-and-Dirty-Tracking
class DatasetForm < Hyrax::Forms::PcdmObjectForm(Dataset)
  include Hyrax::FormFields(:basic_metadata)
  property :complex_person, primary: true, required: true, populator: :complex_person_populator
  property :complex_funding_reference, populator: :complex_funding_reference_populator
  property :complex_relation, populator: :complex_relation_populator
  property :complex_date, populator: :complex_date_populator

  include Hyrax::FormFields(:dataset)
  include PopulatorBehavior
  self.required_fields =
    [
      # Adding all required fields in order of display in form
      :title, :complex_person, :description, :resource_type, :keyword, :license
    ]

  def required_tab_terms
    [:title, :complex_person, :description, :resource_type, :keyword, :license]
  end

  def tabs
    if self.persisted? && self.member_ids.any?
      %w[required description references funding dataset_thumbnail files relationships]
    else
      %w[required description references funding files relationships]
    end
  end

  def description_tab_terms
    # Date, Subject, Language, Location, Version, Resource Type
    [
      :alternative_title,
      :complex_date,
      :subject,
      :language,
      :based_near,
      :software_version,
    ]
  end

  def references_tab_terms
    [
      # Related Items, ID
      :complex_relation
    ]
  end

  def funding_tab_terms
    [
      :complex_funding_reference,
    ]
  end
end
