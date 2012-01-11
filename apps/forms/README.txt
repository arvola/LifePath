Example form:

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
        .msg "Password is required."
end

* no_memory disables the form keeping its value after an unsuccessful submission
* Each "msg" sets the error message for all rules that came before it, but it doesn't overwrite ones that
  already have an error message