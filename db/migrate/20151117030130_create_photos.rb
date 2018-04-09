class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string :url
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
