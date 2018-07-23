class CreateBooking < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.belongs_to :item, class_name: 'Item', foreign_key: 'item_id'
      t.belongs_to :renter, class_name: 'User', foreign_key: 'user_id'
      t.date :start_date
      t.date :end_date
      t.decimal :cost
    end
  end
end
