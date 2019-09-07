class CreateFavoraites < ActiveRecord::Migration[5.2]
  def change
    create_table :favoraites do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true

      t.timestamps
      
      t.index [:user_id, :micropost_id], unique: true
    end
  end
end
