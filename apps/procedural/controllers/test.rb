data = {foo: 0, id: session.user_id}
if post?
    msg = LoginForm.validate(post)
    data[:msg] = msg
end
j['testvar'] = "foobarvar"
j['testvar2'] = {foo: "bar"}
puts slim :test, data