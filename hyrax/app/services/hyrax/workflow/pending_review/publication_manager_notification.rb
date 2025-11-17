# frozen_string_literal: true

module Hyrax
  module Workflow
    module PendingReview
      class PublicationManagerNotification < AbstractNotification
        private

        def subject
          I18n.t('hyrax.notifications.workflow.pending_review.subject')
        end

        def message
          I18n.t('hyrax.notifications.workflow.pending_review.message', title: title, link: (link_to work_id, document_path), user: depositor.user_key, comment: comment)
        end

        def users_to_notify
          collection = @entity.proxy_for.parent_collections.first

          ::User.includes(:roles).where(roles: { name: "publication_manager" }).to_a
        end

        def depositor
          ::User.find_by(email: @entity.proxy_for.depositor)
        end
      end
    end
  end
end
