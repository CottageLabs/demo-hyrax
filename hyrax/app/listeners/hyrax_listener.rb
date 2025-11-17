module Hyrax
  module Listeners
    module LifecycleListenerHelper
      def after_create_callbacks(object)
        user ||= ::User.find_by_user_key(object.depositor)
        case object.class.name
        when 'Dataset'
          object = set_default_source_and_tombstone_status(object)
        end

        object.save
        object.save_index
        object
      end

      private

      def set_default_source_and_tombstone_status(object)
        object.source = object.source.present? ? object.source : [SecureRandom.uuid]
        object.is_tombstoned = false
        object
      end
    end
  end
end