# frozen_string_literal: true
module ComplexField
  module FundrefIndexer
    def to_solr
      super.tap do |index_document|
        index_fundref(index_document)
      end
    end

    def index_fundref(index_document)
      # funding reference resource in json
      fld_name = "complex_funding_reference_ssm"
      index_document[fld_name] = resource.complex_funding_reference.to_json
      # funder_identifier - symbol
      fld_name = "funder_identifier_ssim"
      index_document[fld_name] = resource.complex_funding_reference.map { |r| Array(r.fetch(:funder_identifier, [])).reject(&:blank?).first }
          
      # funder_name - searchable
      fld_name = "funder_tesim"
      index_document[fld_name] = resource.complex_funding_reference.map { |r| Array(r.fetch(:funder_name, [])).reject(&:blank?).first }
      # funder_name - facetable
      fld_name = "funder_sim"
      index_document[fld_name] = resource.complex_funding_reference.map { |r|  Array(r.fetch(:funder_name, [])).reject(&:blank?).first }
      # award_number - symbol
      fld_name = "award_number_ssim"
      index_document[fld_name] = resource.complex_funding_reference.map { |r| Array(r.fetch(:award_number, [])).reject(&:blank?).first }
      # award_title - searchable
      fld_name = "award_title_tesim"
      index_document[fld_name] = resource.complex_funding_reference.map { |r| Array(r.fetch(:award_title, [])).reject(&:blank?).first}
    end

    def self.fundref_facet_fields
      # solr fields that will be treated as facets
      fields = []
      fields << "funder_sim"
      fields
    end

    def self.fundref_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << "funder_identifier_ssim"
      fields << "funder_tesim"
      fields << "award_number_ssim"
      fields << "award_title_tesim"
      fields
    end

    def self.fundref_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << "complex_funding_reference_ssm"
      fields
    end
  end
end
