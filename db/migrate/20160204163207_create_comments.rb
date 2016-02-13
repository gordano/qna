class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, index: true, foreign_key: true
      t.string :commentable_type
      t.string :commentable_id

      t.timestamps null: false
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
