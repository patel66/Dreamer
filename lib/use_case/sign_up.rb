module DMR
  class SignUp < UseCase
    def run(data)
      user = DMR.db.get_user_by_email(data[:email])
      if user != nil
        return failure :email_taken
      else
        user = DMR.db.create_user({ email: data[:email], password: data[:password],
                            full_name: data[:full_name], birthdate: data[:birthdate],
                            phone: data[:phone] })
        session = DMR.db.create_session(user.id)
        return success :session_id => session.id
      end
    end
  end
end
