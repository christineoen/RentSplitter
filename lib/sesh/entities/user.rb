require 'digest/sha1'

module ShowMeMoney
  class User
    attr_reader :username, :display_name, :password_digest, :user_id, :domicile_id, :rent

    def initialize(data = {})
      @username = data[:username]
      @display_name = data[:display_name]
      @password_digest = data[:password_digest]
      @user_id = data[:user_id]
      @domicile_id = data[:domicile_id]
      @rent = data[:rent]
    end

    def update_password(password)
      @password_digest = Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA1.hexdigest(password) == @password_digest
    end

    def update_user_id(user_id)
      @user_id = user_id
    end

    def update_domicile_id(domicile_id)
      @domicile_id = domicile_id
    end

  end
end