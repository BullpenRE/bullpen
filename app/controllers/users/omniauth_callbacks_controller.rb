# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController

    class UnacceptableSocialError < StandardError
    end

    rescue_from Users::Authorizers::BaseAuthorizer::EmailNotPresentError,
                UnacceptableSocialError,
                with: ->(exception) { render_error 500, exception }

    def google
      authorize_social('google')
    end

    def failure
      set_flash_message :alert, :failure
      redirect_to new_user_session_path
    end

    def google_identity
      GoogleSignIn::Identity.new(flash['google_sign_in']['id_token'])
    end

    private

    def authorize_social(provider)
      authorizer = authorizer_for(provider)
      case authorizer.src
      when 'registrations#new'
        authorize_new_registration(authorizer)
      else
        authorize_new_session(authorizer)
      end
    end

    def authorizer_for(provider)
      case provider
      when 'google'
        Users::Authorizers::GoogleAuthorizer.new(google_identity, params)
      else
        raise UnacceptableSocialError, "Unacceptable social provider '#{provider}'"
      end
    end

    def authorize_new_session(authorizer)
      user = User.find_by(email: authorizer.email)

      if user.present?
        set_flash_message(:notice, :success, { kind: authorizer.provider.capitalize })
        sign_in_user(updated_user(user, authorizer.user_data))
      else
        set_flash_message(:alert, :not_found, { email: authorizer.email, path: join_path(email: authorizer.email) })
        redirect_to new_user_session_path
      end
    end

    def updated_user(user, user_data)
      user.uid = user_data[:uid]
      user.provider = user_data[:provider]
      user.confirmed_at = Time.current if user.confirmed_at.blank?

      user
    end

    def authorize_new_registration(authorizer)
      user = authorizer.find_or_create_user!
      sign_in_user(user)
    end

    def sign_in_user(user)
      if params[:src] == 'registrations#new'
        sign_in user

        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect user, event: :authentication
      end
    end

    def after_sign_in_path_for(resource)
      super
    end

  end
end
