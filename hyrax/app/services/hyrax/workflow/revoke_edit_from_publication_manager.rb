# frozen_string_literal: true
module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    # removes the creators the ability to alter it.
    module RevokeEditFromPublicationManager
      def self.call(target:, **)
        model = target.try(:model) || target

        group_key = "publication_manager"

        model.edit_groups = model.edit_groups.to_a + Array.wrap(group_key) # += works in Ruby 2.6+
        model.try(:permission_manager)&.acl&.save

        RevokeEditFromGroupJob.perform_later(model, group_key)
      end
    end
  end
end