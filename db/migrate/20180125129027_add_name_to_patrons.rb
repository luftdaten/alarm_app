class AddNameToPatrons < ActiveRecord::Migration[5.0]
  def change
    add_column :patrons, :name, :string
    add_column :patrons, :forum_moderator, :boolean
    add_column :patrons, :forum_admin, :boolean
  end
end
