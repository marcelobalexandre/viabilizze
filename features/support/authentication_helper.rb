module AuthenticationHelper
  def create_visitor
    @visitor = { name: "Visitor", 
                 email: "example@example.com",
                 password: "password", 
                 password_confirmation: "password" }
  end

  def create_user
    create_visitor
    delete_user
    @user = FactoryGirl.create(:user, @visitor)
  end

  def delete_user
    @user ||= User.where(email: @visitor[:email]).first
    @user.destroy unless @user.nil?
  end

  def sign_up
    visit '/pt-BR/users/sign_up'
    fill_in "user_name", with: @visitor[:name]
    fill_in "user_email", with: @visitor[:email]
    fill_in "user_password", with: @visitor[:password]
    fill_in "user_password_confirmation", with: @visitor[:password_confirmation]
    click_button "Criar Conta"

    @user = User.where(email: @visitor[:email]).first
  end  

  def sign_in(remember_me = false)
    visit '/pt-BR/users/sign_in'
    fill_in "user_email", with: @visitor[:email]
    fill_in "user_password", with: @visitor[:password]
    check "user_remember_me" if remember_me
    click_button "Entrar"

    @user = User.where(email: @visitor[:email]).first
  end

  def sign_in_with_remember_me_checked  
    sign_in(true)
  end

  def sign_in_with_remember_me_unchecked
    sign_in(false)
  end

  def request_password_reset_with_email
    visit '/pt-BR/users/password/new'
    fill_in "user_email", with: @user[:email]
  end
end

World(AuthenticationHelper) if respond_to?(:World)
World(ShowMeTheCookies) if respond_to?(:World)