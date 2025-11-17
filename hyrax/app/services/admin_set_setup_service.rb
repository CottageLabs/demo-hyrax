module AdminSetSetupService
  def create_admin_set_and_workflow(group)
    supported_groups = ["mediated"]
    case group.downcase
    when 'mediated'
      title = 'Mediated deposit workflow'
      workflow_name = 'mediated_deposit_workflow'
      new_admin_set = create_or_find_admin_set(title)
      activate_workflow(new_admin_set.id.to_s, workflow_name)
      add_participants_and_visibility(new_admin_set.id.to_s)
    else
      raise StandardError, "Group #{group} not found. Available options are #{supported_groups}"
    end
  end

  def create_or_find_admin_set(title)
    admin_set = AdminSetHelper.find_by(title: [title])
    admin_set = Hyrax::AdministrativeSet.new(title: [title]) unless admin_set
    admin_role = Role.find_by(name: "admin")
    admin_user = admin_role&.users&.first
    updated_admin_set = Hyrax.persister.save(resource: admin_set)

    Hyrax::AdminSetCreateService.call(admin_set: updated_admin_set, creating_user: admin_user)
    updated_admin_set
    puts "Created admin set for #{title}"
  end

  def activate_workflow(admin_set_id, workflow_name)
    permission_template = Hyrax::PermissionTemplate.find_by(source_id: admin_set_id)

    mediated_workflow = permission_template.available_workflows.where(name: workflow_name).first

    Sipity::Workflow.activate!(permission_template: permission_template, workflow_id: mediated_workflow.id)
    puts "Activated workflow #{workflow_name}"
  end

  def add_participants_and_visibility(admin_set_id)
    permission_template = Hyrax::PermissionTemplate.find_by(source_id: admin_set_id)
    permission_template_form = Hyrax::Forms::PermissionTemplateForm.new(permission_template)
    # pub_manager = ENV.fetch('SYSTEM_PUBLICATION_MANAGER', 'publication_manager@hyrax')
    # manager = {access_grants_attributes:{'0'=> {agent_type: "user", agent_id: pub_manager, access:"manage"}}}
    # permission_template_form.update(manager)
    managers = {access_grants_attributes:{'0'=> {agent_type: "group", agent_id: 'publication_manager', access:"manage"}}}
    permission_template_form.update(managers)
    permission_template_form.update(managers)
    depositors = {access_grants_attributes:{'0'=> {agent_type: "group", agent_id: 'registered', access:"deposit"}}}
    permission_template_form.update(depositors)
    # Set visibility
    visibility_params = {
      release_period: Hyrax::PermissionTemplate::RELEASE_TEXT_VALUE_NO_DELAY,
      visibility: 'restricted'
    }
    permission_template_form.update(visibility_params)
  end

end