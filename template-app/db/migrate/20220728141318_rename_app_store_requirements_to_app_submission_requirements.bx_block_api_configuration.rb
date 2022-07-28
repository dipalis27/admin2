class RenameAppStoreRequirementsToAppSubmissionRequirements < ActiveRecord::Migration[6.0]
  def up
    rename_table :app_store_requirements, :app_submission_requirements
    rename_column :app_categories, :app_store_requirement_id, :app_submission_requirement_id
  end

  def down
    rename_table :app_submission_requirements, :app_store_requirements
    rename_column :app_categories, :app_submission_requirement_id, :app_store_requirement_id
  end
end
