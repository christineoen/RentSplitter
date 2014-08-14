module ShowMeMoney
  class Expense
    attr_reader :type, :amount, :paid_by, :month, :year

    def initialize(data = {})
      @type = data[:type]
      @amount = data[:amount]
      @paid_by = data[:paid_by]
      @month = data[:month]
      @year = data[:year]
    end



  end

end
