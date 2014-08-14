module ShowMeMoney
  class Domicile
    attr_reader :rent, :tenant

    def initialize(data = {})
      @rent = data[:rent]
      @tenant = data[:tenant]
    end


  end
end
