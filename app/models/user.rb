class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  has_many :items, foreign_key: 'owner_id', dependent: :destroy
  has_many :reviews, foreign_key: 'author_id', dependent: :destroy
  has_many :received_reviews, class_name: 'Review', as: :reviewable, dependent: :destroy
  has_many :received_item_reviews, through: :items, source: :received_reviews
  has_many :bookings, foreign_key: 'renter_id', dependent: :destroy
  has_many :payed_transactions, class_name: 'MoneyTransaction', foreign_key: 'payer'
  has_many :received_transactions, class_name: 'MoneyTransaction', foreign_key: 'payee'
  belongs_to :city, optional: true

  has_secure_password

  def pay_to(user, money)
    ans = user.transaction do
      withdrawal(money)
      user.deposit(money)
    end
  end

  before_validation(on: :create) do
    self.balance ||= 0
  end

  protected

  def withdrawal(money)
    self.balance -= money
    save!
  end

  def deposit(money)
    self.balance += money
    save!
  end
end