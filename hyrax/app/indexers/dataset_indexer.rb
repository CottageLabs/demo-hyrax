# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Dataset`
class DatasetIndexer < Hyrax::Indexers::PcdmObjectIndexer(Dataset)
  include Hyrax::Indexer(:basic_metadata)
  include Hyrax::Indexer(:dataset)
  include Hyrax::IndexesWorkflow
  # Custom indexers for dataset model
  include ComplexField::PersonIndexer
  include ComplexField::DateIndexer
  include ComplexField::IdentifierIndexer
  include ComplexField::FundrefIndexer
  include ComplexField::RelationIndexer

  # Uncomment this block if you want to add custom indexing behavior:
  def to_solr
    super.tap do |index_document|
      if resource.title and resource.title.first.present?
        index_document[:title_anssort] = resource.title[0]
      end
      index_document[:member_of_collections_ssim] = resource.parent_collections&.first&.title if resource.persisted?
      index_document.compact_blank
    end
  end

  def self.facet_fields
    # solr fields that will be treated as facets
    super.tap do |fields|
      fields.concat ComplexField::DateIndexer.date_facet_fields
      fields.concat ComplexField::PersonIndexer.person_facet_fields
      fields.concat ComplexField::FundrefIndexer.fundref_facet_fields
    end
  end

  def self.search_fields
    # solr fields that will be used for a search
    super.tap do |fields|
      fields.concat ComplexField::IdentifierIndexer.identifier_search_fields
      fields.concat ComplexField::DateIndexer.date_search_fields
      fields.concat ComplexField::PersonIndexer.person_search_fields
      fields.concat ComplexField::FundrefIndexer.fundref_search_fields
    end
  end

  def self.show_fields
    # solr fields that will be used to display results on the record page
    super.tap do |fields|
      fields.concat ComplexField::IdentifierIndexer.identifier_show_fields
      fields.concat ComplexField::DateIndexer.date_show_fields
      fields.concat ComplexField::PersonIndexer.person_show_fields
      fields.concat ComplexField::FundrefIndexer.fundref_show_fields
    end
  end

end
