# frozen_string_literal: true
module Hyrax
  # Grants read access for the supplied group for the members attached to a work
  class GrantReadToGroupJob < ApplicationJob
    include MembersPermissionJobBehavior

    def perform(work, group_key)
      # Iterate over ids because reifying objects is slow.
      file_set_ids(work).each do |file_set_id|
        # Call this synchronously, since we're already in a job
        FileSets::GrantReadJob.perform_now(file_set_id, group_key)
      end
    end
  end
end