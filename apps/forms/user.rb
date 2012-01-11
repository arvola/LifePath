
class UserForm < Rapid::Form
    form_item(:user)
        .required
        .msg "Username is required."

    form_item(:pass)
        .required
        .no_memory
        .msg "Password is required."

    form_item(:email)
        .required
        .msg "Email is required."
end