class CreateReview < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.belongs_to :owner, foreign_key: true
      t.text :description
      t.integer :reviewable_id
      t.string :reviewable_type
    end

    add_index :reviews, [:reviewable_type, :reviewable_id]
  end
end
