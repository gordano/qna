class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    ##########################################render json: User.find_for_oauth(request.env['omniauth.auth'])
    #render json: request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted? # если пользователь сохранён
      sign_in_and_redirect @user, event: :authentication # убеждаемся что пользователь прошел все проверки типа подверждения
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format? #выводим сообщение о успешной уатентификации если формат вывода позволяет это сделать например html
    end
  end
end
