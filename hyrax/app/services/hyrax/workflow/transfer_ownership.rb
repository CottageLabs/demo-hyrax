module Hyrax
  module Workflow
    ##
    # This is a built in function for workflow, so that a workflow action can be created that
    #  Transfer Ownership for dataset
    module TransferOwnership
      def self.call(target:, **)
        model = target.try(:model) || target
        user_email = ENV.fetch('SYSTEM_PUBLICATION_MANAGER', 'publication_manager@hyrax')
        user = ::User.find_by(email: user_email)
        target.proxy_depositor = target.depositor
        target.depositor = user.user_key
      end
    end
  end
end
