# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    # Genrate DOI for dataset
    module RegisterDoi
      def self.call(target:, **)
        # model = target.try(:model) || target
        # RegisterDoiWorker.perform_async(model.id.to_s) if ENV.fetch('REGISTER_DOI', 'true') == 'true'

        return true
      end
    end
  end
end
