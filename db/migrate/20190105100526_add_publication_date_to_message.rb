class AddPublicationDateToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :publication_date, :date
  end
end
