# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "onboard"
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
  end

  def update_resource(resource, params)
    if avatar_only_update?(resource, params)
      resource.update_without_password(params.except(:current_password))
    else
      super
    end
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def avatar_only_update?(resource, params)
    params[:avatar].present? &&
      params[:password].blank? &&
      params[:password_confirmation].blank? &&
      params[:current_password].blank? &&
      params[:email] == resource.email
  end
end
