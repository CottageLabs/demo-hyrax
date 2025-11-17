module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    # Genrate DOI for dataset
    module TombstoneInitiate
      def self.call(target:, user:, **)
        model = target.try(:model) || target
        model.intialize_tombstone!(user)
      end
    end
  end
end
