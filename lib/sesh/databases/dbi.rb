require 'pg'
require 'digest/sha1'

module ShowMeMoney
  class DBI
    attr_reader :db
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'show_me_the_money')

      users = %q[
        CREATE TABLE IF NOT EXISTS users(
          id SERIAL,
          username text,
          password text,
          PRIMARY KEY (id)
          );]
      @db.exec(users)

      expenses = %q[
        CREATE TABLE IF NOT EXISTS expenses(
          id SERIAL,
          type text, 
          amount integer, 
          paid_by integer REFERENCES users(id),
          month text,
          year integer,
          PRIMARY KEY ( id )
          );]
      @db.exec(expenses)

      domicile = %q[
        CREATE TABLE IF NOT EXISTS domicile(
          id SERIAL,
          rent integer, 
          tenant integer REFERENCES users(id),
          PRIMARY KEY ( id )
          );]
      @db.exec(domicile)

      # TODO: Figure out rent and bills logic!!

      # Uncomment after sh*t figured out!

    end

    def persist_user(user)
      @db.exec(%q[
        INSERT INTO users (username, password)
        VALUES ($1, $2);
      ], [user.username, user.password_digest])
    end

    def create_user(username, password)
      create = <<-SQL
      INSERT INTO users (username, password)
      VALUES ('#{username}', '#{password}');
      SQL
      @db.exec(create)
    end

    def username_exists?(username)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE username = '#{username}';
      ])

      if result.count > 0
        true
      else
        false
      end
    end

    def get_player_by_id(id)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE id = #{id};
      ])

      user_data = result.first
      
      if user_data
        build_user(user_data)
      else
        nil
      end
    end

    def build_user(data)
      RPS::User.new(data['username'], data['password'])
    end

    def get_player_by_username(username)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE username = '#{username}';
      ])

      user_data = result.first
      
      if user_data
        build_user(user_data)
      else
        nil
      end
    end

    def get_player_id(username)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE username = '#{username}';
      ])

      user_data = result.first
      
      if user_data
        user_data['id']
      else
        nil
      end
    end

    def update_password(password, user_id)
      update = <<-SQL
      UPDATE users SET
      password = '#{password}'
      WHERE id = #{user_id};
      SQL
      @db.exec(update)
    end

    def get_all_users(current_users_id);
      select = <<-SQL
      SELECT * FROM users WHERE id != '#{current_users_id}';
      SQL
      @db.exec(select)
    end

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



    def build_domicile(data)
      ShowMeMoney::Domicile.new(data)
    end


    def add_domicile(rent, tenant)
      result = @db.exec_params(%q[
        INSERT INTO domicile (rent, tenant)
        VALUES ($1, $2)
        RETURNING *;
        ], [rent, tenant])
      
      build_domicile(result.first)
    end

  end

  def self.dbi
    @__db_instance ||= DBI.new
  end

end