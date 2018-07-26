class CreateOption < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.belongs_to :filter, foreign_key: true
      t.string :option_value
    end
  end
end
