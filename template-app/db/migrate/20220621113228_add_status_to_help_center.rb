class AddStatusToHelpCenter < ActiveRecord::Migration[6.0]
  def change
    add_column :help_centers, :status, :integer, default: 1
  end
end
