namespace :hyrax_demo do
  namespace :admin_user do
    desc 'Create system administrator'
    task :create => :environment do
      user_hash = {
        "email": ENV.fetch('SYSTEM_ADMINISTRATOR', 'admin@hyrax'),
        "password": "password",
        "name": "Hyrax admin",
        "role": "admin"
      }
      puts "Creating system administrator"
      admin_role = Role.where(name: "admin").first_or_create!
      admin_user = User.find_by(email: user_hash[:email])
      unless admin_user
        admin_user = User.new(
          email: user_hash[:email],
          display_name: user_hash[:name],
          password: user_hash[:password]
        )

        admin_user.save!
        admin_role.users << admin_user
        admin_role.save!
      end
    end
  end
end
