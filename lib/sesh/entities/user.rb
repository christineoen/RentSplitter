require 'digest/sha1'

module ShowMeMoney
  class User
    attr_reader :username, :password_digest

    def initialize(data = {})
      @username = data[:username]
      @password_digest = data[:password_digest]
    end

    def update_password(password)
      @password_digest = Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA1.hexdigest(password) == @password_digest
    end
  end
end