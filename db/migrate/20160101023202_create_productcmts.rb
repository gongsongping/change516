class CreateProductcmts < ActiveRecord::Migration[5.1]
  def change
    create_table :productcmts do |t|
      t.string :content
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :productcmts, :users
  end
end
