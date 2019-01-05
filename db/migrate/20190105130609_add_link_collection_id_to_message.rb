class AddLinkCollectionIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :link_collection_id, :integer
  end
end
