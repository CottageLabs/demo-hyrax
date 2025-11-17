# app/controllers/errors_controller.rb

class ErrorsController < ApplicationController

  def not_found
    render template: 'errors/error_message'
  end

  def internal_server_error
    render template: 'errors/error_message'
  end

  def unprocessable_entity
    render template: 'errors/error_message'
  end

  def access_forbidden
    render template: 'errors/error_message'
  end
end
