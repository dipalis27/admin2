module BxBlockAdmin
  class AccountSerializer < BuilderBase::BaseSerializer
    attributes :id, :full_name, :email, :type
  end
end