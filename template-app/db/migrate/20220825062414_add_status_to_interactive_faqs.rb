class AddStatusToInteractiveFaqs < ActiveRecord::Migration[6.0]
  def change
    add_column :interactive_faqs, :status, :integer, default: 1
  end
end
