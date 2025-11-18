# frozen_string_literal: true
module Hyrax
  class RemoveAssociatedObjectsJob < ApplicationJob
    def perform(work_id, user_id)
      user = ::User.find(user_id)
      work = Hyrax.query_service.find_by(id: work_id)

      work.file_sets.each do |file_set|
        transactions = Hyrax::Transactions::Container

        transactions['file_set.destroy']
          .with_step_args('file_set.remove_from_work' => { user: user },
                          'file_set.delete' => { user: user })
          .call(file_set)
          .value!
      end
    end
  end
end