# frozen_string_literal: true
module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    # grants the creator the ability to view their work.
    module GrantReadToPublicationManager
      # @param [#read_users=, #read_users] target to which we are adding read_users
      #   for the depositor
      # @return void
      def self.call(target:, **)
        model = target.try(:model) || target # get the model if target is a ChangeSet
        collection = model.parent_collections.first

        group_key = "publication_manager"
        model.read_groups = model.read_groups.to_a + Array.wrap(group_key) # += works in Ruby 2.6+
        model.try(:permission_manager)&.acl&.save

        GrantReadToGroupJob.perform_later(model, group_key)
      end
    end
  end
end