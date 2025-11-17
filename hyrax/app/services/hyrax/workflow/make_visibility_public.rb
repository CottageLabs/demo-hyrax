module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    #  Transfer Ownership for dataset
    module MakeVisibilityPublic
      def self.call(target:, **)
        model = target.try(:model) || target
        model.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC 
        model.try(:permission_manager)&.acl&.save

        VisibilityCopyJob.perform_later(model)
        model
      end
    end
  end
end
