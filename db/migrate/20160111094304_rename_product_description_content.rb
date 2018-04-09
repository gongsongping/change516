class RenameProductDescriptionContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :description, :content
  end
end
