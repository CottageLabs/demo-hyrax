# frozen_string_literal: true
namespace :hyrax_demo do
  namespace :workflow_admin_sets do
    desc "Create the Default Admin Sets for the workflows"
    task create: :environment do
      admin_role = Role.find_by(name: "admin")
      admin_user = admin_role&.users&.first
      if admin_user.present?
        include AdminSetSetupService
        create_admin_set_and_workflow("mediated")
      else
        puts "Admin Sets not created, No Admin user exists."
      end
    end
  end
end