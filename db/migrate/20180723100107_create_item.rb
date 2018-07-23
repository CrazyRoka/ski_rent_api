class CreateItem < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :daily_price_cents
      t.references :owner, references: :user, foreign_key: {to_table: :users}
      t.timestamps
    end
  end
end
