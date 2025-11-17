module ComplexField
  module RelationIndexer
    def to_solr
      super.tap do |index_document|
        index_relation(index_document)
      end
    end

    def index_relation(index_document)
      index_document["complex_relation_ssm"] = resource.complex_relation.to_json
      index_document["complex_relation_title_tesim"] = resource.complex_relation.map { |r| Array(r.fetch(:title, [])).reject(&:blank?).first }
      resource.complex_relation.each do |r|
        unless Array(r.fetch(:title)).blank? || Array(r.fetch(:relationship)).blank? || only_blank_strings?(r.fetch(:relationship))
          fld_name = "complex_relation_relationship_sim"
          index_document[fld_name] = [] unless index_document.include?(fld_name)
          index_document[fld_name] << Array(r.fetch(:relationship)).reject(&:blank?)
          index_document[fld_name].flatten!
          relationship = Array(r.fetch(:relationship,[])).reject(&:blank?).first.downcase.tr(' ', '_')
          fld_name = "complex_relation_#{relationship}_sim"
          index_document[fld_name] = [] unless index_document.include?(fld_name)
          index_document[fld_name] << Array(r.fetch(:title,[])).reject(&:blank?)
          index_document[fld_name].flatten!

          fld_name = "complex_relation_#{relationship}_tesim"
          index_document[fld_name] = [] unless index_document.include?(fld_name)
          index_document[fld_name] << Array(r.fetch(:title,[])).reject(&:blank?)
          index_document[fld_name].flatten!
        end
      end
    end

    ##
    # If the complex relation is only an array of blank strings, it doesn't need to be indexed
    # @return [Boolean]
    def only_blank_strings?(relationship)
      relationship.delete("")
      relationship.empty?
    end
  end
end
