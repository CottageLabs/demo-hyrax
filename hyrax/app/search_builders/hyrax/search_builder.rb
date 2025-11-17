# frozen_string_literal: true
module Hyrax
  class SearchBuilder < ::SearchBuilder
    self.default_processor_chain += [:filter_tombstone]

    def filter_tombstone(solr_parameters)
      return true unless self.is_a?(Hyrax::Dashboard::WorksSearchBuilder)

      unless current_user.present? && solr_parameters[:fq].include?("{!term f=is_tombstoned_ssim}true") 
        solr_parameters[:fq] <<  "{!terms f=is_tombstoned_ssim}false"
      end
    end
  end
end