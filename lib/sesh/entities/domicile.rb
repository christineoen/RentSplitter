module ShowMeMoney
  class Domicile
    attr_reader :rent, :tenant, :year, :month, :domicile_id

    def initialize(data = {})
      @rent = data[:rent]
      @tenant = data[:tenant]
      @year = data[:year]
      @month = data[:month]
      @domicile_id = data[:domicile_id]
    end

    def get_all_expenses_for_domicile
      ShowMeMoney.dbi.get_all_expenses()
    end

  end
end
