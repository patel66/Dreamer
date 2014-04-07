module DMR
  class User

    attr_accessor :id
    attr_reader :username, :password, :full_name, :birthdate, :phone, :email

    def initialize(data)  # username, password, fullname, birthdate, phone
      @id = data[:id]
      @username = data[:username]
      @password = data[:password]
      @full_name = data[:full_name]
      @birthdate = data[:birthdate]
      @phone = data[:phone]
      @email = data[:email]
    end

  end
end
