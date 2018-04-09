class CreateStalkertargets < ActiveRecord::Migration[5.1]
  def change
    create_table :stalkertargets do |t|
      t.integer :stalker_id, index: true
      t.integer :target_id, index: true
      t.timestamps null: false
    end
  end
end
