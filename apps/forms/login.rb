
class LoginForm < Rapid::Form
    form_item(:user)
        .required
        .msg("Username is required.")
        .min_length(4)
        .max_length(10)
        .msg "Username must be between 4 and 10 characters long."

    form_item(:pass)
        .required
        .no_memory
        .min_length(5)
        .msg "Password must be at least 5 characters long."
end