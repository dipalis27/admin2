module BxBlockAdmin
  class CountrySerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :code, :created_at, :updated_at
    attribute :currency do |object|
      object.currency
    end
  end
end