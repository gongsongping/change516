class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email#,index: true
      t.string :password_digest
      t.string :token, index: true
      t.string :json
      t.string :avatar
      t.timestamps
    end
    # add_index  :users, :json, using: :gin
    add_index :users, :email, unique: true
  end
end
# create_table :users do |t|
#   t.string :name
#   t.string :email
#   t.boolean :admin
#   t.string :password_digest
#   t.json :json, default: {is_foing:[]}
#   t.timestamps null: false
# end
# add_column :users, :home_page_url, :string
# rename_column :users, :email, :email_address
# change_table :products do |t|
#   t.remove :description, :name
#   t.string :part_number
#   t.index :part_number
#   t.rename :upccode, :upc_code
# end
