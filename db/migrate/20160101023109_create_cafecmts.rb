class CreateCafecmts < ActiveRecord::Migration[5.1]
  def change
    create_table :cafecmts do |t|
      t.string :content
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :cafecmts, :users
  end
end
