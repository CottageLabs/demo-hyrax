# frozen_string_literal: true

module Hyrax
  module Workflow
    module SentForReview
      class DepositorNotification < AbstractNotification
        private

        def subject
          I18n.t('hyrax.notifications.workflow.sent_for_review.subject')
        end

        def message
          I18n.t('hyrax.notifications.workflow.sent_for_review.message', title: title,
                                                                                            link: (link_to work_id, document_path),
                                                                                            user: user.user_key, comment: comment, approval_from: approval_from)
        end

        def users_to_notify
          [::User.find_by(email: @entity.proxy_for.depositor)]
        end

        def approval_from
          case @entity.workflow_state.name
          when "pending_review_from_group_manager"
            "group manager"
          when "pending_review_from_crc_manager"
            "crc manager"
          when "pending_review_from_publication_manager"
            "publication manager"
          end
        end
      end
    end
  end
end
