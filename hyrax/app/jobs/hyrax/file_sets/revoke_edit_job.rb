

# frozen_string_literal: true
module Hyrax
  module FileSets
    # Revokes the group edit access on the provided FileSet
    class RevokeEditJob < ApplicationJob
      include PermissionJobBehavior

      def perform(file_set_id, group_key)
        file_set = Hyrax::FileSet.find(file_set_id)
        file_set.edit_groups = file_set.edit_groups.to_a - Array.wrap(group_key) # += works in Ruby 2.6+
        file_set.try(:permission_manager)&.acl&.save
      end
    end
  end
end