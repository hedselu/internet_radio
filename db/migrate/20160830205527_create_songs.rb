class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title, null: false, index: true
      t.string :author
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
