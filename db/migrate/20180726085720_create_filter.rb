class CreateFilter < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.belongs_to :category, foreign_key: true
      t.string :filter_name
    end
  end
end
