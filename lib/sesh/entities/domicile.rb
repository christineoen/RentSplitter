module ShowMeMoney
  class Domicile
    attr_reader :domicile_id, :reallocation_hash

    def initialize(data = {})
      # @rent = data[:rent]
      # @tenant = data[:tenant]
      # @year = data[:year]
      # @month = data[:month]
      @name = data['name']
      @domicile_id = data['domicile_id']
      @reallocation_hash = Hash.new(0)
    end

    def self.reallocate
      user_object_array = ShowMeMoney.dbi.get_domicile_users(domicile_id)

      # user_object_array.each |user| do
      #   @reallocation_hash[user] = 0
      # end
      expense_object_array = ShowMeMoney.dbi.get_all_expenses(domicile_id, year, month)
      expense_object_array.each do |expense|
        user_object_array.each do |user|
          if expense.paid_by == user.user_id
            @reallocation_hash[user.user_id] -= expense.amount / user_object_array.count * (user_object_array.count - 1)
          else
            @reallocation_hash[user.user_id] += expense.amount / user_object_array.count
          end
        end
      end
      return @reallocation_hash
    end



  end
end
#
# temp_array = []
#    
# user_object_array.each |user| do
#   temp_array.push({ user => 0})
# end
# 
# expenses.each |expense| do
#    compare user_id of expense with each element in temp_array
#    if user_id = expense.paid_by
#         subtract
#    else
#       add
#    end
# end
#
# temp_array = [{user1 => -30}, {user2 => 60}, {user3 => -30}]
# 
# 
# return hash with users => their reallocation
# 
# 
# 
# 
# 
# 
# 
# 
# 
# =>      def self.reallocate 
#           user.domicile_id
#
#           ShowMeMoney.dbi.get_expenses_total(user)
# =>           SELECT amount FROM expenses 
#              WHERE user_id = $1 AND domicile_id = $2;
#              , [user.id, user.domicile_id]
             # .to_i
#            #expenses_total
           #ShowMeMoney.dbi.get_all_tenants_domicile(user)
           #    SELECT user_id FROM domicile
           #    WHERE domicile_id = $1   
           #  ], user.domicile_id]
             # returns (some array).count
             # expenses_total/^^ (number of tenants)


             #  60


             
             

           # ShowMeMoney.dbi




             # inject +

             #  .to_i :+


             # return total_
# =>      end
#
# =>     
#
#
#