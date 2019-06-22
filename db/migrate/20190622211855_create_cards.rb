class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :cost
      t.string :type
      t.string :kind
      t.string :rarity
      t.text :description
      t.text :quotation

      t.timestamps
    end
  end
end
