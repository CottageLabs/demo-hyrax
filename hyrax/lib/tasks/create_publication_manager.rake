namespace :hyrax_demo do
  namespace :publication_manager do
    desc 'Create system publication manager'
    task :create => :environment do
      user_hash = {
        "email": ENV.fetch('SYSTEM_PUBLICATION_MANAGER', 'publication_manager@hyrax'),
        "name": "Publication Manager",
        "role": "publication_manager"
      }
      puts "Creating system publication manager"
      _success, messages, _user = User.create_user_from_hash(user_hash, update_user: false)

      puts messages if messages.any?
    end
    task :update => :environment do
      user_hash = {
        "email": ENV.fetch('SYSTEM_PUBLICATION_MANAGER', 'publication_manager@hyrax'),
        "name": "Publication Manager",
        "role": "publication_manager"
      }
      puts "Updating system publication manager"
      _success, messages, _user = User.create_user_from_hash(user_hash, update_user: true)

      puts messages if messages.any?
    end
  end
end
