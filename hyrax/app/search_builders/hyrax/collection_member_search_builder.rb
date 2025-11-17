# frozen_string_literal: true
module Hyrax
  # This search builder requires that a accessor named "collection" exists in the scope
  class CollectionMemberSearchBuilder < ::Hyrax::CollectionSearchBuilder
    include Hyrax::FilterByType
    attr_writer :collection, :search_includes_models

    class_attribute :collection_membership_field, :crc_work_type_field, :is_tombstoned_field
    self.collection_membership_field = 'member_of_collection_ids_ssim'
    self.is_tombstoned_field = 'is_tombstoned_ssim'

    # Defines which search_params_logic should be used when searching for Collection members
    self.default_processor_chain -= %i[only_active_works]
    self.default_processor_chain += %i[member_of_collection filter_by_is_tombstoned filter_by_active_works sort_by_attributes]

    # @param [Object] scope Typically the controller object
    # @param [Symbol] search_includes_models +:works+ or +:collections+; (anything else retrieves both)
    def initialize(*args,
                   scope: nil,
                   collection: nil,
                   search_includes_models: nil,
                   search_includes_is_tombstoned: false,
                   search_includes_only_active_works: false,
                   sorting_attribute: 'title_si',
                   sorting_direction: 'asc')
      @collection = collection
      @search_includes_models = search_includes_models
      @search_includes_crc_work_type = search_includes_crc_work_type
      @search_includes_is_tombstoned = search_includes_is_tombstoned
      @search_includes_only_active_works = search_includes_only_active_works
      @sorting_attribute = sorting_attribute
      @sorting_direction = sorting_direction
      if args.any?
        super(*args)
      else
        super(scope)
      end
    end

    def collection
      @collection || (scope.context[:collection] if scope&.respond_to?(:context))
    end

    def search_includes_models
      @search_includes_models || :works
    end

    attr_accessor :search_includes_crc_work_type, :search_includes_is_tombstoned, :search_includes_only_active_works, :sorting_attribute, :sorting_direction

    def sort_by_attributes(solr_parameters)
      solr_parameters[:sort] = "#{sorting_attribute} #{sorting_direction}"
    end

    # include filters into the query to only include the collection memebers
    def member_of_collection(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "#{collection_membership_field}:#{collection.id}"
    end

    def filter_by_is_tombstoned(solr_parameters)
      return unless search_includes_is_tombstoned.present?

      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "#{is_tombstoned_field}:#{search_includes_is_tombstoned}"
    end

    def filter_by_active_works(solr_parameters)
      return unless search_includes_only_active_works

      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << '-suppressed_bsi:true'
    end

    # This overrides the models in FilterByType
    def models
      work_classes + collection_classes
    end

    private

    def only_works?
      search_includes_models == :works
    end

    def only_collections?
      search_includes_models == :collections
    end
  end
end
