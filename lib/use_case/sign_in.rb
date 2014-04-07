module DMR
  class SignIn < UseCase
    def run(data)
      user = DMR.db.get_user_by_email(data[:email])
      if user == nil
        return failure(:email_not_found)
      elsif user.password != data[:password]
        return failure(:incorrect_password)
      else
        session = DMR.db.create_session(user.id)
        return success :session_id => session.id
      end
    end
  end
end
