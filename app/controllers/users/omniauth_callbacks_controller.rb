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
      authorize_new_session(authorizer)
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
        sign_in_user(updated_user(user, authorizer.user_data))
      else
        set_flash_message(:alert, :not_found, { email: authorizer.email })
        redirect_to new_user_session_path
      end
    end

    def updated_user(user, user_data)
      user.uid = user_data[:uid] unless user.uid
      user.provider = user_data[:provider] unless user.provider
      user.confirmed_at = Time.current unless user.confirmed_at

      user
    end

    def sign_in_user(user)
      sign_in_and_redirect user, event: :authentication
    end

    def after_sign_in_path_for(resource)
      super
    end

  end
end
