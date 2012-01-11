
class LoginForm < Rapid::Form
    form_item(:email)
        .required
        .msg "E-mail is required."

    form_item(:pass)
        .required
        .no_memory
        .msg "Password is required."
end