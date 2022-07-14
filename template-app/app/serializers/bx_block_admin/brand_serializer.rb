# == Schema Information
#
# Table name: brand
#
#  id                   :bigint           not null, primary key
#  name                 :string

module BxBlockAdmin
  class BrandSerializer < BuilderBase::BaseSerializer
    attributes :name
  end
end