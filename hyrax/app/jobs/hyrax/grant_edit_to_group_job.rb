# frozen_string_literal: true
module Hyrax
  # Grants edit access for the supplied group for the members attached to a work
  class GrantEditToGroupJob < ApplicationJob
    include MembersPermissionJobBehavior

    def perform(work, group_key)
      # Iterate over ids because reifying objects is slow.
      file_set_ids(work).each do |file_set_id|
        # Call this synchronously, since we're already in a job
        FileSets::GrantEditJob.perform_now(file_set_id, group_key)
      end
    end
  end
end