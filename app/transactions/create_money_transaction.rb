class CreateMoneyTransaction
  include Dry::Transaction

  step :validate
  step :perform_payment
  step :create

  def validate(input)
    return Success(input) if input[:payer].balance >= input[:payment_cents]
    Failure("User with id #{input[:payer].id} has not enough money")
  end

  def perform_payment(input)
    transaction = User.transaction do
      input[:payer].withdrawal(input[:payment_cents])
      input[:payee].deposit(input[:payment_cents])
    end
    return Success(input) if transaction
    Failure("Failure in performing transaction")
  end

  def create(input)
    money_transaction = MoneyTransaction.create(input)
    return Success(money_transaction) if money_transaction.persisted?
    Failure("Can't create money transaction")
  end
end