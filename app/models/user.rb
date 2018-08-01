class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_destroy :conserve_transactions

  has_many :items, foreign_key: 'owner_id', dependent: :destroy
  has_many :reviews, foreign_key: 'author_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
  has_many :received_item_reviews, through: :items, source: :received_reviews
  has_many :bookings, foreign_key: 'renter_id', dependent: :destroy
  has_many :payed_transactions, class_name: 'MoneyTransaction', foreign_key: 'payer'
  has_many :received_transactions, class_name: 'MoneyTransaction', foreign_key: 'payee'
  belongs_to :city, optional: true

  has_secure_password

  def withdrawal(money)
    self.balance -= money
    save!
  end

  def deposit(money)
    self.balance += money
    save!
  end

  private

  def conserve_transactions
    ghost = User.find_by_email('ghost@email.com')
    payed_transactions.each do |transaction|
      transaction.payer = ghost
      transaction.save
    end

    received_transactions.each do |transaction|
      transaction.payee = ghost
      transaction.save
    end
  end
end
