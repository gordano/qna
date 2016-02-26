class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :omiauth_callback, except: [:failure]

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end

  def facebook
  end

  def twitter
  end

  def finish_registration

  end


  private
    def omiauth_callback
      @user = User.find_for_oauth(get_auth)
      if @user && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: get_auth.provider.capitalize) if is_navigational_format?
      else
        session[:provider] = request.env['omniauth.auth'].provider
        session[:uid] = request.env['omniauth.auth'].uid
        render 'omniauth_callbacks/add_email'
      end
    end
    def get_auth
      if request.env['omniauth.auth']
        request.env['omniauth.auth']
      else
        OmniAuth::AuthHash.new(provider: session[:provider], uid: session[:uid], info: { email: params[:user][:email] })
      end
    end
end
