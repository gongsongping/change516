class AddNationalityCityAgeTelenumberDescriptionCafeshopAdminToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nationality, :string
    add_column :users, :city, :string
    add_column :users, :age, :integer
    add_column :users, :telenumber, :string
    add_column :users, :description, :string
    add_column :users, :cafeshop, :boolean
    add_column :users, :admin, :boolean
  end
end
