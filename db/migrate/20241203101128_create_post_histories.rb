class CreatePostHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :post_histories do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :action
      t.text :comment

      t.timestamps
    end
  end
end
