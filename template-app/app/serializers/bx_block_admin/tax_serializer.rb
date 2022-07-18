# == Schema Information
#
# Table name: taxes  ( Model -> BxBlockOrderManagement::Tax )
#
#  id                   :bigint           not null, primary key
#  tax_percentage       :float

module BxBlockAdmin
  class TaxSerializer < BuilderBase::BaseSerializer
    attributes :tax_percentage, :created_at, :updated_at
    
  end
end