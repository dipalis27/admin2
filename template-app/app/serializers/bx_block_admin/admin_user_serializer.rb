module BxBlockAdmin
  class AdminUserSerializer < BuilderBase::BaseSerializer
    attributes :id, :email, :phone_number, :name, :role

    attribute :permissions do |object|
      object.admin_permissions
    end
  end
end
