class MoneyTransaction < ApplicationRecord
  belongs_to :payer, class_name: 'User'
  belongs_to :payee, class_name: 'User'
  belongs_to :target, polymorphic: true
end