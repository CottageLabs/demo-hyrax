

# frozen_string_literal: true
module Hyrax
  module FileSets
    # Grants the group read access on the provided FileSet
    class GrantReadJob < ApplicationJob
      include PermissionJobBehavior

      def perform(file_set_id, group_key)
        file_set = Hyrax::FileSet.find(file_set_id)
        file_set.read_groups = file_set.read_groups.to_a + Array.wrap(group_key) # += works in Ruby 2.6+
        file_set.try(:permission_manager)&.acl&.save
      end
    end
  end
end