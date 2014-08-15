module ShowMeMoney
  class Domicile
    attr_reader :domicile_id, :reallocation_hash

    def initialize(data = {})
      @domicile_id = data['domicile_id']
      @reallocation_hash = Hash.new(0)
    end

    def reallocate(year, month)
      user_object_array = ShowMeMoney.dbi.get_domicile_users(domicile_id)
      expense_object_array = ShowMeMoney.dbi.get_all_expenses(domicile_id, year, month)
      expense_object_array.each do |expense|
        user_object_array.each do |user|
          if expense.paid_by == user.user_id
            @reallocation_hash[user.user_id] -= expense.amount.to_i / user_object_array.count * (user_object_array.count - 1)
          else
            @reallocation_hash[user.user_id] += expense.amount.to_i / user_object_array.count
          end
        end
      end
      return @reallocation_hash
    end
    
  end
end