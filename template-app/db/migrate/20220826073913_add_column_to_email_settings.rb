class AddColumnToEmailSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :email_settings, :active, :boolean, default: true
  end
end
