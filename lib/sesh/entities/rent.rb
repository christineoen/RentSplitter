module ShowMeMoney
  class Rent
    attr_reader :amount, :roomie

    def initialize(data = {})
      @amount = data[:amount]
      @roomie = data[:roomie]
    end


  end
end
