require 'hyrax/downloads_controller'

Rails.application.config.to_prepare do
  Hyrax::DownloadsController.class_eval do
    def file_set_parent(file_set_id)
      file_set =
        if defined?(Wings) && !Hyrax.config.disable_wings && Hyrax.metadata_adapter.is_a?(Wings::Valkyrie::MetadataAdapter)
          Hyrax.query_service.find_by_alternate_identifier(
            alternate_identifier: file_set_id, 
            use_valkyrie: Hyrax.config.use_valkyrie?
          )
        else
          Hyrax.query_service.find_by(id: file_set_id)
        end
      @parent ||=
        case file_set
        when Hyrax::Resource
          Hyrax.custom_queries.find_parent_work(resource: file_set)
        else
          file_set.parent
        end
    end
  end
end
