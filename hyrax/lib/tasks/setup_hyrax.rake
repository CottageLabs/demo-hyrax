namespace :hyrax_demo do
  desc 'Setup Hyrax, will read from specified file usage: hyrax_demo:setup_hyrax["setup.json"]'
  task :"setup_hyrax", [:seedfile] => :environment do |task, args|
    seedfile = args.seedfile

    unless args.seedfile.present?
      seedfile = Rails.root.join("seed","setup.json")
    end

    ##############################################
    # Start creating admin users, publication manager and S3 bucket
    ######
    Rake::Task['hyrax_demo:admin_user:create'].invoke
    Rake::Task['hyrax_demo:publication_manager:create'].invoke
    ######
    # finished creating admin users
    ##############################################

    ##############################################
    # Start load workflows, create default collection types and administrative sets
    ######
    Rake::Task['hyrax:workflow:load'].invoke
    Rake::Task['hyrax:default_collection_types:create'].invoke
    Rake::Task['hyrax:default_admin_set:create'].invoke
    Rake::Task['hyrax_demo:workflow_admin_sets:create'].invoke
    # the publication manager has manage role for the workflow, but not approving.
    # Approving role can only be assigned after workflow is created, not before.
    # Re-assigning the role publication manager helps acquire the approving permission.
    Rake::Task['hyrax_demo:publication_manager:update'].invoke
    ######
    # Finished loading workflows, creating collection types and administrative sets
    ##############################################

    ##############################################
    # Start creating CRC collection, and creating other users
    ######
    if (File.exist?(seedfile))
      Rake::Task["hyrax_demo:setup_users"].invoke(seedfile, true)
    end
    ######
    # finished creating CRC collection, S3 bucket and creating other users
    ##############################################

    ##############################################
    # Create languages controlled vocabulary
    ######
    Rake::Task['hyrax:controlled_vocabularies:language'].invoke if Qa::Authorities::Local.subauthority_for('languages').all.size == 0
    ######
    # finished creating languages controlled vocabulary
    ##############################################
  end
end
