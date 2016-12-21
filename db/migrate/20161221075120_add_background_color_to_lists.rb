class AddBackgroundColorToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :background_color, :string, default: '#ffffff'
  end
end
