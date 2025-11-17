class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  include AppRoles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def can_tombstone?(presenter)
    self.admin?
  end

  def is_depositor_for?(presenter)
    presenter.depositor == self.user_key
  end

  def workflow_action_permission?(presenter)
    group_id = presenter.member_of_collection_ids.first
    state = presenter.workflow.state

    return false if state == 'draft' && !is_depositor_for?(presenter)

    admin? || is_depositor_for?(presenter)  || publication_manager?
  end

  def self.assign_user_to_role(user, user_hash)
    user_hash = ActiveSupport::HashWithIndifferentAccess.new(user_hash)
    role_name = user_hash.fetch('role', nil)
    group_id = user_hash.fetch('group_id', nil)
    return true, '' if role_name.blank?

    role = if %w(admin publication_manager ).include?(role_name)
             Role.find_or_create_by(name: role_name, is_system_generated: true)
           end

    unless role.present?
      return false, "Error: #{role_name} is not a valid role"
    end

    role.users << user if role.users.where(id: user.id).blank?
    role.save

    user.add_workflow_role(role)
    return true, "Assigned user #{user.email} role #{role.name}"
  end

  def self.find_by_hash(user_hash)
    user_hash = ActiveSupport::HashWithIndifferentAccess.new(user_hash)
    user = nil
    if user_hash.fetch('email', nil).present?
      user = User.find_by(email: user_hash['email'])
    end
    user
  end

  def self.find_or_create_user_email(user_hash)
    user_hash = ActiveSupport::HashWithIndifferentAccess.new(user_hash)
    email = nil
    if user_hash.fetch('email', nil).present?
      email = user_hash['email']
    end
    email
  end

  def self.create_user_from_hash(user_hash, update_user: false)
    user_hash = ActiveSupport::HashWithIndifferentAccess.new(user_hash)
    messages = []
    user = User.find_by_hash(user_hash)

    email = user ? user.email : User.find_or_create_user_email(user_hash)

    if user.present? and not update_user
      messages << "Warning: User #{email} already exists. Not updating user."
      return false, messages, user
    elsif user.blank? and email.blank?
      messages << "Error: Not creating user. User has no email, saml id, or orcid."
      return false, messages, nil
    elsif user.present? and update_user
      messages << "Updating user #{email}"
    elsif user.blank?
      messages << "Creating user #{email}"
      user = User.new
    end

    return false, messages, nil unless user.present?

    # email
    user.email = email

    # password
    if user_hash.fetch('password', nil).present?
      user.password = user_hash['password']
    elsif user.encrypted_password.blank?
      user.password = SecureRandom.base64(32)
    end

    # display name
    user.display_name = user_hash["name"] if user_hash.fetch('name', nil).present?

    # save and assign role
    if user.save
      _success, message = User.assign_user_to_role(user, user_hash)
      messages << message
    else
      messages << "Error: #{user.errors.full_messages}"
    end
    return true, messages, user
  end

  %w(add remove).each do |action|
    define_method("#{action}_workflow_role") do |role|
      case role.name
      when 'publication_manager'
        handle_publication_manager_role(action)
      else
        return
      end
    end
  end

  private

  def handle_publication_manager_role(action)
    titles = [
      ENV.fetch('CRC_ADMIN_SET_TITLE', 'CRC 1280 Publishing Workflow'),
      ENV.fetch('RUB_ADMIN_SET_TITLE', 'RUB publication workflow')
    ]

    titles.each do |title|
      admin_set = AdminSetHelper.find_by(title: [title])
      next if admin_set.nil?
      add_or_remove_responsibility(admin_set, 'approving_publication_manager', action)
    end
  end

  def add_or_remove_responsibility(admin_set, role_name, action)
    active_workflow = Sipity::Workflow.find_active_workflow_for(admin_set_id: admin_set.id)
    workflow_role = Sipity::WorkflowRole.joins(:role).where(workflow_id: active_workflow.id, sipity_roles: {name: role_name}).first
    user_agent = Sipity::Agent.find_or_create_by(proxy_for_id: id, proxy_for_type: 'User')

    if action == 'add'
      Sipity::WorkflowResponsibility.find_or_create_by(agent_id: user_agent.id, workflow_role_id: workflow_role.id)
    else
      Sipity::WorkflowResponsibility.find_by(agent_id: user_agent.id, workflow_role_id: workflow_role.id)&.destroy
    end
  end

end
