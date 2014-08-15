module ShowMeMoney
  class Expense
    attr_reader :type, :amount, :paid_by, :month, :year, :domicile_id

    def initialize(data = {})
      @type = data['type']
      @amount = data['amount']
      @paid_by = data['paid_by']
      @month = data['month']
      @year = data['year']
      @domicile_id = data['domicile_id']
    end

    def get_display_name
      ShowMeMoney.dbi.get_display_name(paid_by)
    end

  end
end
