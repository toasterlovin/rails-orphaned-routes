class CreateThings < ActiveRecord::Migration[4.2]
  def change
    create_table :things do |t|
      t.string :name

      t.timestamps
    end
  end
end
