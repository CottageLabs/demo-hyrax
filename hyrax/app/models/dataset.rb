# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Dataset`
class Dataset < Hyrax::Work
  attribute :complex_person , Valkyrie::Types::Array.of(Valkyrie::Types::String)
  attribute :complex_funding_reference , Valkyrie::Types::Array.of(Valkyrie::Types::String)
  attribute :complex_relation , Valkyrie::Types::Array.of(Valkyrie::Types::String)
  attribute :complex_date , Valkyrie::Types::Array.of(Valkyrie::Types::String)
  attribute :complex_identifier , Valkyrie::Types::Array.of(Valkyrie::Types::String)
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:dataset)
  include CommonQuery
  include ::Hyrax::TombstoneBehavior
  def default_admin_set
    AdminSetHelper.find_by(title: ['Mediated deposit workflow'])
  end
end
