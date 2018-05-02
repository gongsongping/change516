class CreateCafeposts < ActiveRecord::Migration[5.1]
  def change
    create_table :cafeposts do |t|
      t.references :user, index: true
      t.string :content
      t.string :url

      t.timestamps null: false
    end
    add_foreign_key :cafeposts, :users
  end
end
