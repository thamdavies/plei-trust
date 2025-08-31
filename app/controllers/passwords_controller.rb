class PasswordsController < Clearance::PasswordsController
  def create
    user = User.new(email: email_from_password_params)
    form = Password::Contracts::Create.new(user)

    unless form.validate(permit_password_create)
      @user = form
      return render template: "passwords/new", status: :unprocessable_entity
    end

    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end

    render template: "passwords/create", status: :accepted
  end

  private

  def permit_password_create
    params.require(:password).permit(:email)
  end
end
