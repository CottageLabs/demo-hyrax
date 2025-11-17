# frozen_string_literal: true

module ComplexField
  module IdentifierIndexer
    def to_solr
      super.tap do |index_document|
        index_identifier(index_document)
      end
    end

    def index_identifier(index_document)
      index_document["complex_identifier_ssim"] = resource.complex_identifier.map do |i|
        i.fetch(:identifier)
      end
      index_document["complex_identifier_ssm"] = resource.complex_identifier.to_json
      facetable_ids = %w[group_id project_id]

      resource.complex_identifier.each do |i|
        next unless (i.fetch(:scheme, '').present? || i.fetch(:identifier, '').present?)

        label = i.fetch(:scheme, '').to_s.downcase.tr(' ', '_')
        fld_name = "complex_identifier_#{label}_ssim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << i.fetch(:identifier) if i.fetch(:identifier).present?
        index_document[fld_name].flatten!
        next unless facetable_ids.include?(label)

        fld_name = "complex_identifier_#{label}_sim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << i.fetch(:identifier) if i.fetch(:identifier).present?
        index_document[fld_name].flatten!
      end
    end

    def self.identifier_facet_fields
      # solr fields that will be used for a search
      fields = []
      fields << "complex_identifier_group_id_sim"
      fields << "complex_identifier_project_id_sim"
      fields
    end

    def self.identifier_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << "complex_identifier_ssim"
      fields
    end

    def self.identifier_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << "complex_identifier_ssm"
      fields
    end
  end
end
