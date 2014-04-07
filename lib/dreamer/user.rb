module DMR
  class User

    attr_accessor :id
    attr_reader :username, :password, :full_name, :birthdate, :phone, :email

    def initialize(data)  # password, fullname, birthdate, phone, email
      @id = data[:id]
      @password = data[:password]
      @full_name = data[:full_name]
      @birthdate = data[:birthdate]
      @phone = data[:phone]
      @email = data[:email]
    end

  end
end
