module ShowMeMoney
  class Bill
    attr_reader :name, :amount, :paid_by

    def initialize(data = {})
      @name = data[:name]
      @amount = data[:amount]
      @paid_by = data[:paid_by]
    end


  end

end
