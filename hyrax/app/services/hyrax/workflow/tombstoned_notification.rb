# frozen_string_literal: true
module Hyrax
  module Workflow
    class TombstonedNotification < AbstractNotification
      private

      def subject
        I18n.t('hyrax.notifications.workflow.tombstoned.subject', user: user.user_key)
      end

      def message
        I18n.t('hyrax.notifications.workflow.tombstoned.message',
                title: title,
                link: (link_to work_id, document_path),
                user: user.user_key,
                comment: comment)
      end

      def users_to_notify
        collection = @entity.proxy_for.parent_collections.first

        if @entity.proxy_for.class.to_s == 'Dataset'
          [::User.find_by(email: @entity.proxy_for.depositor)] + [::User.find_by(email: document.proxy_depositor)] + ::User.includes(:roles).where(roles: { name: "publication_manager" }).to_a
        elsif @entity.proxy_for.class.to_s == 'PlasmaDataset'
          [::User.find_by(email: @entity.proxy_for.depositor)] + [::User.find_by(email: document.proxy_depositor)] + ::User.includes(:roles).where(roles: { name: "plasma_manager" }) + ::User.includes(:roles).where(roles: { name: "publication_manager" }).to_a
        else
          [::User.find_by(email: @entity.proxy_for.depositor)] + ::User.includes(:roles).where(roles: { name: "#{collection.collection_type.title.parameterize(separator: '_')}_#{collection.id}_manager", is_crc_group_manager: true }).to_a + ::User.includes(:roles).where(roles: { name: "#{collection.collection_type.title.parameterize(separator: '_')}_manager", is_crc_manager: true }).to_a + ::User.includes(:roles).where(roles: { name: "publication_manager" }).to_a
        end
      end
    end
  end
end
