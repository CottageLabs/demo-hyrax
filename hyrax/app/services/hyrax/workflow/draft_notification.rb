# frozen_string_literal: true

module Hyrax
  module Workflow
    class DraftNotification < AbstractNotification
      private

      def subject
        I18n.t('hyrax.notifications.workflow.draft.subject')
      end

      def message
        I18n.t('hyrax.notifications.workflow.draft.message', title: title,
               link: (link_to work_id, document_path),
               user: user.user_key, comment: comment)
      end

      def users_to_notify
        [::User.find_by(email: @entity.proxy_for.depositor)]
      end
    end
  end
end
