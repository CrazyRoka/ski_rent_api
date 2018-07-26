class CreateItemsAndOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :items_options, id: false do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :option, foreign_key: true
    end
  end
end
