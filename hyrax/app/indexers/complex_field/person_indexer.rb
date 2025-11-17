# frozen_string_literal: true

module ComplexField
  module PersonIndexer
    def to_solr
      super.tap do |index_document|
        index_person(index_document)
      end
    end

    def index_person(index_document)
      begin
        creators = resource.complex_person.map { |c| Array(c.fetch(:first_name, '') + c.fetch(:last_name, '')).reject(&:blank?).join(' ') }
      rescue
        creators = []
      end
      begin
        creators << resource.complex_person.map { |c| Array(c.fetch(:name, '')).reject(&:blank?) }
      rescue
        creators ||= []
      end
      creators = creators.flatten.uniq.reject(&:blank?)
      return index_document unless creators
      index_document["complex_person_tesim"] = creators
      index_document["complex_person_sim"] = creators
      index_document["complex_person_ssm"] = resource.complex_person.to_json
      resource.complex_person.each do |c|
        # index creator by role
        person_name = Array(c.fetch(:first_name,[])).reject(&:blank?)
        person_name =  Array(c.fetch(:first_name, '') + c.fetch(:last_name, '')).reject(&:blank?).join(' ') if person_name.blank?
        label = 'other'
        roles = Array(c.fetch(:role, [])).reject(&:blank?)
        if roles.present? and roles.first
          begin
            label = RoleService.new.label(roles.first)
            label = label.downcase.tr(' ', '_')
          rescue
            label = roles.first.downcase.tr(' ', '_')
          end
        end
        # complex_person by role as stored_searchable
        fld_name = "complex_person_#{label}_tesim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << person_name
        index_document[fld_name].flatten!
        # complex_person by role as facetable
        fld_name = "complex_person_#{label}_sim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << person_name
        index_document[fld_name].flatten!
        # affiliation
        vals = Array(c.fetch(:affiliation,[])).reject(&:blank?)
        fld_name = "complex_person_affiliation_tesim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << vals
        index_document[fld_name] = index_document[fld_name].flatten.uniq
        fld_name = "complex_person_affiliation_ssm"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << vals
        index_document[fld_name] = index_document[fld_name].flatten.uniq
        # orcid
        vals = Array(c.fetch(:orcid,[])).reject(&:blank?)
        fld_name = "complex_person_identifier_ssim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << vals
        index_document[fld_name] = index_document[fld_name].flatten.uniq
      end
    end

    def self.person_facet_fields
      # solr fields that will be treated as facets
      fields = []
      roles = RoleService.new.select_all_options
      roles.each do |r|
        fields << "complex_person_#{r[1].downcase.tr(' ', '_')}_sim"
      end
      fields << "complex_person_affiliation_sim"
      fields
    end

    def self.person_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << "complex_person_tsim"
      fields << "complex_person_identifier_ssim"
      fields << "complex_person_affiliation_tesim"
      fields
    end

    def self.person_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      fields << "complex_person_ssm"
      fields
    end
  end
end
