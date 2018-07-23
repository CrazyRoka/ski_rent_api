class CreateBooking < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.belongs_to :item, foreign_key: true
      t.references :renter, references: :user, foreign_key: {to_table: :users}
      t.date :start_date
      t.date :end_date
      t.integer :cost_cents
      t.timestamps
    end
  end
end
