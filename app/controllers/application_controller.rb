# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authenticable
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authorize_request 
end