class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :post, index: true
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
