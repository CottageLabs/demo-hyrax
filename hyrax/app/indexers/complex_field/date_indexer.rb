# frozen_string_literal: true

module ComplexField
  module DateIndexer
    def to_solr
      super.tap do |index_document|
        index_date(index_document)
      end
    end

    def index_date(index_document)
      return if resource.complex_date.blank?
      # json resource as complex_date displayable
      index_document["complex_date_ssm"] = resource.complex_date.to_json
      # date as complex_date searchable
      dates = resource.complex_date.map { |d| Array( d.fetch(:date, [])).reject(&:blank?) }.flatten
      # cope with just a year being supplied
      begin
        dates_utc = dates.map { |d| d.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') }.map { |d| d.length <= 4 ? DateTime.strptime(d, '%Y').utc.iso8601 : DateTime.parse(d).utc.iso8601 } unless dates.blank?
      rescue ArgumentError
        dates_utc = dates.map { |d| d.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') }.map { |d| DateTime.parse("#{d}-01").utc.iso8601 } unless dates.blank?
      end
      index_document["complex_date_tesim"] = dates_utc unless dates.blank?
      index_document["complex_date_tesim"] = dates_utc unless dates.blank?
      # add year as searchable, facetable and first year as int for date range
      years = dates_utc.map { |d| DateTime.parse(d).strftime('%Y') } unless dates.blank?
      index_document["complex_year_tesim"] = years unless years.blank?
      index_document["complex_year_sim"] = years unless years.blank?
      index_document["complex_year_itsi"] = years.compact.first unless years.blank?
      resource.complex_date.each do |d|
        next if Array(d.fetch(:date, [])).reject(&:blank?).blank?
        label = 'other'
        unless d.fetch(:description, '').blank? 
          # Finding its display label for indexing
          term = DateService.new.find_by_id(d.fetch(:description))
          label = term['label'] if term.any?
        end
        label = label.downcase.tr(' ', '_')
        # Not indexing date as sortbale as it needs to be single valued
        # fld_name = "complex_date_#{label.downcase.tr(' ', '_')}_dtsim"
        # index_document[fld_name] = [] unless index_document.include?(fld_name)
        # index_document[fld_name] << DateTime.parse(d.date.reject(&:blank?).first).utc.iso8601
        # index_document[fld_name] = index_document[fld_name].uniq.first
        # date as complex_date_type dateable
        vals = Array(d.fetch(:date, [])).reject(&:blank?)
        fld_name = "complex_date_#{label}_tesim"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        begin
          dates_utc = vals.map { |d| d.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') }.map { |d| d.length <= 4 ? DateTime.strptime(d, '%Y').utc.iso8601 : DateTime.parse(d).utc.iso8601 } unless dates.blank?
        rescue ArgumentError
          dates_utc = vals.map { |d| d.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z') }.map { |d| DateTime.parse("#{d}-01").utc.iso8601 } unless dates.blank?
        end
        index_document[fld_name] << dates_utc unless dates_utc.blank?
        index_document[fld_name].flatten!
        # Add years as facetable
        year_fld = "complex_year_#{label}_sim"
        years = dates_utc.map { |d| DateTime.parse(d).strftime("%Y") }
        index_document[year_fld] = [] unless index_document.include?(year_fld)
        index_document[year_fld] << years unless years.blank?
        index_document[year_fld].flatten!

        # add first year as int for date range facets
        year_fld_int = "complex_year_#{label}_itsi"
        index_document[year_fld_int] = years.compact.first unless years.blank?
        # date as complex_date_type displayable
        fld_name = "complex_date_#{label}_ssm"
        index_document[fld_name] = [] unless index_document.include?(fld_name)
        index_document[fld_name] << vals
        index_document[fld_name].flatten!
      end
    end

    def self.date_facet_fields
      # solr fields that will be treated as facets
      fields = []
      # change all dates to years
      date_options = DateService.new.select_all_options
      date_options.each do |d|
        fields << "complex_date_#{d[0].downcase.tr(' ', '_')}_tesim"
        fields << "complex_year_#{d[0].downcase.tr(' ', '_')}_itsi"
      end
      fields
    end

    def self.date_search_fields
      # solr fields that will be used for a search
      fields = []
      fields << "complex_date_tesim"
      fields << "complex_year_tesim"
      fields
    end

    def self.date_show_fields
      # solr fields that will be used to display results on the record page
      fields = []
      date_options = DateService.new.select_all_options
      date_options.each do |d|
        fields << "complex_date_#{d[0].downcase.tr(' ', '_')}_ssm"
      end
      fields
    end
  end
end
