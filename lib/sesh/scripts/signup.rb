module ShowMeMoney
  class SignUp
    def self.run(params)
      if params['username'].empty? || params['display_name'].empty? || params['password'].empty? || params['password_confirm'].empty?
        return {:success? => false, :error => "Please fill out all input fields."}
      elsif ShowMeMoney.dbi.username_exists?(params['username'])
        return {:success? => false, :error => "Username already exists. Please choose another username."}
      # elsif ShowMeMoney.dbi.domicile_id_exists?(params['domicile_id'])
      #   return {:success? => false, :error => "Domicile ID not found. Please try again or Sign Up without ID to create new domicile."}
      elsif params['password'] != params['password_confirm']
        return {:success? => false, :error => "Passwords don't match. Please try again."}
      end

      user = ShowMeMoney::User.new(params)
      binding.pry
      user.update_password(params['password'])
      ShowMeMoney.dbi.persist_user(user)
      user_id = ShowMeMoney.dbi.get_user_id(user)
      user.update_user_id(user_id)
      # binding.pry
      if params['domicile_id'] == nil
        domicile = ShowMeMoney.dbi.add_domicile
        user.update_domicile_id(domicile.domicile_id)
      else
        user.update_domicile_id(params['domicile_id'])
      end

      # binding.pry
      {
        :success? => true,
        :session_id => user.user_id
      }
    end
  end
end