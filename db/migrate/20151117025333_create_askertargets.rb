class CreateAskertargets < ActiveRecord::Migration[5.1]
  def change
    create_table :askertargets do |t|
      t.integer :asker_id, index: true
      t.integer :target_id, index: true
      t.boolean :agree
      t.timestamps null: false
    end
  end
end
