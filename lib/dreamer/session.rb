module DMR
  class Session


    attr_accessor :user_id, :id
    def initialize(id, user_id)
      @user_id = user_id
      @id = id
    end
  end
end
