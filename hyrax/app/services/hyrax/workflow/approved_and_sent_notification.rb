# frozen_string_literal: true

module Hyrax
  module Workflow
    class ApprovedAndSentNotification < AbstractNotification
      private

      def subject
        I18n.t('hyrax.notifications.workflow.approved_and_sent.subject')
      end

      def message
        I18n.t('hyrax.notifications.workflow.approved_and_sent.message',
               title: title,
               link: (link_to work_id, document_path),
               user: user.user_key, comment: comment,
               next_approval_from: next_approval_from)
      end

      def users_to_notify
        collection = @entity.proxy_for.parent_collections.first
        if @entity.proxy_for.class.to_s == 'PlasmaDataset'
          [ ::User.find_by(email: @entity.proxy_for.depositor)] +
            ::User.includes(:roles).where(roles: { name: "plasma_manager" }).to_a
        else
          col_type = collection.collection_type.title.parameterize(separator: '_')
          [ ::User.find_by(email: @entity.proxy_for.depositor)] +
            ::User.includes(:roles).where(roles: { name: "#{col_type}_#{collection.id}_manager", is_crc_group_manager: true }).to_a +
            ::User.includes(:roles).where(roles: { name: "#{col_type}_manager", is_crc_manager: true }).to_a
        end
      end

      def next_approval_from
        case @entity.workflow_state.name
        when "pending_review_from_crc_manager"
          "crc manager"
        when "pending_review_from_publication_manager"
          "publication manager"
        end
      end
    end
  end
end
