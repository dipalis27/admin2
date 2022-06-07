module AppRequirement
end

unless Object.const_defined?('::Admin::AppRequirementsController')
  ActiveAdmin.register BxBlockApiConfiguration::AppRequirement, as: 'App Requirement' do
    menu false
    permit_params :requirement_type, :file

    actions :all, except: %i[destroy show]


    action_item :sample_app_requirement do
      link_to 'Sample app requirement', download_admin_brand_settings_path(play_store: false)
    end

    action_item :sample_play_store_requirement do
      link_to 'Sample play store requirement', download_admin_brand_settings_path(play_store: true)
    end

    form do |f|
      f.inputs do
        f.input :requirement_type, as: :select, collection: BxBlockApiConfiguration::AppRequirement.requirement_types.keys.to_a, include_blank: true, allow_blank: false, :prompt => "Select Type"
        f.input :file, :as => :file, :hint => f.object.file.present? ? '' : content_tag(:span, "")
      end
      f.actions
    end

    index :download_links => false do
      column :id
      column :requirement_type
      actions defaults: false do |r|
        link_to 'Download', rails_blob_path(r.file, disposition: 'preview'), class: 'view_link member_link'
      end
      actions
    end

    controller do
      def action_methods
        if BxBlockApiConfiguration::AppRequirement.count > 1
          super - ['new']
        else
          super
        end
      end
    end

  end
end
