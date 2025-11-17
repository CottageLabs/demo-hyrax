# frozen_string_literal: true

module Hyrax
  module Workflow
    class ApprovedNotification < AbstractNotification
      private

      def subject
        I18n.t('hyrax.notifications.workflow.approved.subject', user_role: user_role)
      end

      def message
        I18n.t('hyrax.notifications.workflow.approved.message',
               title: title, link: (link_to work_id, document_path),
               user: user.user_key, comment: comment, user_role: user_role)
      end

      def users_to_notify
        case @entity.workflow_state.name
        when "pending_review_from_crc_manager"
          collection = @entity.proxy_for.parent_collections.first
          col_type = collection.collection_type.title.parameterize(separator: '_')
          ::User.includes(:roles).where(roles: { name: "#{col_type}_manager", is_crc_manager: true }).to_a
        when "pending_review_from_publication_manager"
          ::User.includes(:roles).where(roles: { name: "publication_manager" }).to_a
        when "pending_review_from_plasma_manager"
          ::User.includes(:roles).where(roles: { name: "plasma_manager" }).to_a
        end
      end

      def user_role
        if @entity.proxy_for.class.to_s == 'PlasmaDataset'
          "Plasma manager"
        else
          collection = @entity.proxy_for.parent_collections.first
          if user.crc_manager_for?(collection.id)
            'Crc Manager'
          elsif user.group_manager_for?(collection.id)
            'Group Manager'
          end
        end
      end
    end
  end
end
