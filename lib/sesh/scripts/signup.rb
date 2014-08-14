module ShowMeMoney
  class SignUp
    def self.run(params)
      if params['username'].empty? || params['display_name'].empty? || params['password'].empty? || params['password_confirm'].empty?
        return {:success? => false, :error => "Please fill out all input fields."}
      elsif RPS.dbi.username_exists?(params['username'])
        return {:success? => false, :error => "Username already exists. Please choose another username."}
      elsif params['password'] != params['password_confirm']
        return {:success? => false, :error => "Passwords don't match.  Please try again."}
      end

      user = RPS::User.new(params['username'])
      user.update_password(params['password'])
      RPS.dbi.persist_user(user)
      user_id = RPS.dbi.get_user_id(user)
      user.update_user_id(user_id)

      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end