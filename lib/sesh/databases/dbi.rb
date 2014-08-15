require 'pg'
require 'digest/sha1'

module ShowMeMoney
  class DBI
    attr_reader :db
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'show_me_the_money')

      domicile = %q[
        CREATE TABLE IF NOT EXISTS domicile(
          domicile_id SERIAL,
          PRIMARY KEY ( domicile_id )
          );]
      @db.exec(domicile)

      users = %q[
        CREATE TABLE IF NOT EXISTS users(
          user_id SERIAL,
          username text,
          display_name text,
          password text,
          rent integer,
          domicile_id integer REFERENCES domicile(domicile_id),
          PRIMARY KEY ( user_id )
          );]
      @db.exec(users)

      ########bug for domicile_id??#######
      expenses = %q[
        CREATE TABLE IF NOT EXISTS expenses(
          expense_id SERIAL,
          type text, 
          amount integer, 
          paid_by integer REFERENCES users(user_id),
          month integer,
          year integer,
          domicile_id integer REFERENCES domicile(domicile_id), 
          PRIMARY KEY ( expense_id )
          );]
      @db.exec(expenses)

      # TODO: Figure out rent and bills logic!!

      # Uncomment after sh*t figured out!

    end

    #### USERS ####

    def build_user(data)
      ShowMeMoney::User.new(data['username'], data['display_name'], data['password'])
    end

    def persist_user(user)
      @db.exec_params(%q[
        INSERT INTO users (username, display_name, password)
        VALUES ($1, $2, $3);
      ], [user.username, user.display_name, user.password_digest])
    end

    def get_user_id(user)
      result = @db.exec_params(%q[
        SELECT user_id from users
        WHERE username = $1;
        ], [user.username])

      return result.first
    end

    def username_exists?(username)
      result = @db.exec(%q[
        SELECT * FROM users
        WHERE username = $1;
      ], [username])

      if result.count > 0
        true
      else
        false
      end
    end

    def get_user_by_id(user_id)
      result = @db.exec(%q[
        SELECT * FROM users 
        WHERE user_id = $1;
      ],[user_id])

      user_data = result.first
      
      if user_data
        build_user(user_data)
      else
        nil
      end
    end

    def get_user_by_username(username)
      result = @db.exec(%q[
        SELECT * FROM users 
        WHERE username = $1;
      ],[username])

      user_data = result.first
      
      if user_data
        build_user(user_data)
      else
        nil
      end
    end


    #### EXPENSES ####

    def build_expense(data)
      ShowMeMoney::Expense.new(data)
    end

    def add_expense(type, amount, paid_by, month, year)
      result = @db.exec_params(%q[
        INSERT INTO expenses (type, amount, paid_by, month, year)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING *;
        ], [type, amount, paid_by, month, year])

      build_expense(result.first)
    end

    def get_all_expenses(domicile_id, year, month)
      result = @db.exec(%q[
        SELECT * FROM expenses
        WHERE domicile_id = $1
        AND year = $2
        AND month = $3;
        ],[domicile_id, year, month])

      result.map {|row| build_expense(row)}
    end

    #### DOMICILE ####

    def build_domicile(data)
      ShowMeMoney::Domicile.new(data)
    end


    def add_domicile
      result = @db.exec(%q[
        INSERT INTO domicile DEFAULT VALUES
        RETURNING *;
        ])
      
      build_domicile(result.first)
    end

    def get_domicile_id(user_id)
      result = @db.exec(%q[
        SELECT domicile_id FROM users
        WHERE user_id = $1
        ],[user_id])

      return result.first
    end

    def get_domicile_users(domicile_id)
      result = @db.exec_params(%q[
        SELECT # FROM users
        WHERE domicile_id = $1;
        ],[domicile_id])
      
      result.map {|row| build_user(row)}
    end

    # def domicile_id_exists?(domicile_id)
    #   result = @db.exec(%q[
    #     SELECT * FROM domicile
    #     WHERE domicile_id = $1;
    #   ], [domicile_id])

    #   if result.count > 0
    #     true
    #   else
    #     false
    #   end
    # end

  end

  def self.dbi
    @__db_instance ||= DBI.new
  end

end