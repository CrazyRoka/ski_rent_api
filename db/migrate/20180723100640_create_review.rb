class CreateReview < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :author, references: :user, foreign_key: {to_table: :users}
      t.text :description
      t.references :reviewable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
