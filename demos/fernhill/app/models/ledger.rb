# frozen_string_literal: true

# Fictional data for a made-up product. A real app would load this from a database.
class Ledger
  Account = Struct.new(:name, :number, :kind, :icon, :balance, :change)
  Transaction = Struct.new(:merchant, :category, :icon, :date, :account, :amount, :status)
  Budget = Struct.new(:name, :icon, :spent, :limit)
  Month = Struct.new(:name, :income, :spending)
  Bill = Struct.new(:name, :due, :amount, :note)

  ACCOUNT_NAMES = ["Everyday Checking", "Rainy Day Savings", "Index Portfolio"].freeze

  def initialize(transfers = [])
    @transfers = transfers
  end

  def accounts
    [
      Account.new(name: ACCOUNT_NAMES[0], number: "•••• 4021", kind: "Checking", icon: "landmark",
        balance: 8_412.56 + transferred(ACCOUNT_NAMES[0]), change: 2.4),
      Account.new(name: ACCOUNT_NAMES[1], number: "•••• 7788", kind: "Savings", icon: "piggy-bank",
        balance: 24_930.11 + transferred(ACCOUNT_NAMES[1]), change: 0.6),
      Account.new(name: ACCOUNT_NAMES[2], number: "•••• 1190", kind: "Investments", icon: "chart-line",
        balance: 61_204.87 + transferred(ACCOUNT_NAMES[2]), change: -1.3)
    ]
  end

  def net_worth = accounts.sum(&:balance)
  def monthly_income = months.last.income
  def monthly_spending = months.last.spending
  def savings_rate = ((monthly_income - monthly_spending) / monthly_income * 100).round

  def months
    [
      Month.new(name: "Jun", income: 6_200.0, spending: 4_310.0),
      Month.new(name: "Jul", income: 6_200.0, spending: 4_980.0),
      Month.new(name: "Aug", income: 6_850.0, spending: 3_940.0),
      Month.new(name: "Sep", income: 6_200.0, spending: 4_120.0),
      Month.new(name: "Oct", income: 6_200.0, spending: 5_230.0),
      Month.new(name: "Nov", income: 6_400.0, spending: 3_684.0)
    ]
  end

  def chart_ceiling = months.flat_map { |month| [month.income, month.spending] }.max

  def budgets
    [
      Budget.new(name: "Groceries", icon: "shopping-cart", spent: 412.0, limit: 600.0),
      Budget.new(name: "Dining out", icon: "coffee", spent: 268.0, limit: 250.0),
      Budget.new(name: "Transport", icon: "car", spent: 96.0, limit: 180.0),
      Budget.new(name: "Utilities", icon: "zap", spent: 142.0, limit: 220.0)
    ]
  end

  def bills
    [
      Bill.new(name: "Rent", due: "Dec 1", amount: 1_850.0, note: "Paid automatically from Everyday Checking."),
      Bill.new(name: "Hearthline Energy", due: "Nov 18", amount: 86.4, note: "Estimated from your last three bills."),
      Bill.new(name: "Streamly", due: "Nov 21", amount: 15.99,
        note: "Renews monthly. Cancel any time before the due date.")
    ]
  end

  def transactions
    pending_transfers + [
      Transaction.new(merchant: "Greenleaf Market", category: "Groceries", icon: "shopping-cart", date: "Nov 6",
        account: "Everyday Checking", amount: -84.32, status: :pending),
      Transaction.new(merchant: "Acme Payroll", category: "Income", icon: "briefcase", date: "Nov 5",
        account: "Everyday Checking", amount: 3_200.0, status: :completed),
      Transaction.new(merchant: "Corner Roasters", category: "Dining out", icon: "coffee", date: "Nov 5",
        account: "Everyday Checking", amount: -6.75, status: :completed),
      Transaction.new(merchant: "Metro Transit", category: "Transport", icon: "car", date: "Nov 4",
        account: "Everyday Checking", amount: -48.0, status: :completed),
      Transaction.new(merchant: "Hearthline Energy", category: "Utilities", icon: "zap", date: "Nov 3",
        account: "Everyday Checking", amount: -91.18, status: :failed),
      Transaction.new(merchant: "Index Fund Purchase", category: "Investing", icon: "chart-line", date: "Nov 1",
        account: "Index Portfolio", amount: -500.0, status: :completed),
      Transaction.new(merchant: "Rent", category: "Housing", icon: "house", date: "Nov 1",
        account: "Everyday Checking", amount: -1_850.0, status: :completed)
    ]
  end

  private

  def transferred(account)
    @transfers.sum do |transfer|
      amount = transfer["amount"].to_f
      (transfer["to"] == account ? amount : 0) - (transfer["from"] == account ? amount : 0)
    end
  end

  def pending_transfers
    @transfers.reverse.map do |transfer|
      Transaction.new(merchant: "Transfer to #{transfer['to']}", category: "Transfer", icon: "arrow-left-right",
        date: "Today", account: transfer["from"], amount: -transfer["amount"].to_f, status: :pending)
    end
  end
end
