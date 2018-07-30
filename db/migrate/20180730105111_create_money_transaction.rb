class CreateMoneyTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :money_transactions do |t|
      t.references :payer, references: :user, foreign_key: {to_table: :users}
      t.references :payee, references: :user, foreign_key: {to_table: :users}
      t.references :target, polymorphic: true, index: true
      t.integer :payment_cents, default: 0
    end
  end
end
