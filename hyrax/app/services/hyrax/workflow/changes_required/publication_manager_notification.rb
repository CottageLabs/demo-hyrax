# frozen_string_literal: true

module Hyrax
  module Workflow
    module ChangesRequired
      class PublicationManagerNotification < AbstractNotification
        private

        def subject
          I18n.t('hyrax.notifications.workflow.changes_required.subject')
        end

        def message
          I18n.t('hyrax.notifications.workflow.changes_required.message',
                title: title,
                link: (link_to work_id, document_path),
                comment: comment)
        end

        def users_to_notify
          collection = @entity.proxy_for.parent_collections.first
          if @entity.proxy_for.class.to_s == 'PlasmaDataset'
            ::User.includes(:roles).where(roles: { name: "plasma_manager"}).to_a
          else
            ::User.includes(:roles).where(roles: { name: "#{collection.collection_type.title.parameterize(separator: '_')}_manager", is_crc_manager: true }).to_a
          end
        end
      end
    end
  end
end
