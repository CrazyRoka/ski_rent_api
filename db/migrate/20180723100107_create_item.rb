class CreateItem < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :daily_price
      t.belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
    end
  end
end
