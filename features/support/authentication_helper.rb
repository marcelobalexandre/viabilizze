module AuthenticationHelper
  def create_visitor
    @visitor = { name: "Visitor", 
                 email: "example@example.com",
                 password: "password", 
                 password_confirmation: "password" }
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
end

World(AuthenticationHelper) if respond_to?(:World)