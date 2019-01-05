class CreateLinkCollections < ActiveRecord::Migration
  def change
    create_table :link_collections do |t|
      t.date :news_date
      t.text :link

      t.timestamps null: false
    end
  end
end
