require 'rails_helper'

RSpec.describe BxBlockCatalogue::Catalogue, type: :model do
  let(:catalogue) { FactoryBot.build(:catalogue) }

  context "validation for catalogue model" do
    
    it 'should be an invalid object ' do
      catalogue_new = described_class.new
      expect(catalogue_new.valid?).to eq(false)
    end

    it 'should be a valid object, if we assign all the values' do
      expect(catalogue.valid?).to eql(true)
    end

    it 'checks presence of name' do
      catalogue.name = nil
      expect(catalogue).not_to be_valid
    end

    it 'checks presence of price' do
      catalogue.price = nil
      expect(catalogue).not_to be_valid
    end

    it 'checks presence of stock_qty' do
      catalogue.stock_qty = nil
      expect(catalogue).not_to be_valid
    end

    it 'checks uniqueness of sku' do
      catalogue_create = FactoryBot.create(:catalogue) 
      catalogue_new = FactoryBot.build(:catalogue, sku: catalogue_create.sku)
      expect(catalogue_new).not_to be_valid
      expect(catalogue_new.errors[:sku]).to include("has already been taken")
    end

    it 'checks presence of sale_price, if on_sale is activated' do
      catalogue.on_sale = true
      expect(catalogue).not_to be_valid
      catalogue.sale_price = catalogue.price - 2
      expect(catalogue).to be_valid
    end

    it 'checks sale_price should lesser than price' do
      catalogue.on_sale = true
      catalogue.sale_price = catalogue.price + 1
      expect(catalogue).not_to be_valid 
      catalogue.sale_price = catalogue.price + 1
      catalogue.valid?
      expect(catalogue.errors[:sale_price]).to include("can not be greater then price")
    end

    it 'checks for weight >= zero or weight <= 10' do
      expect(catalogue.weight).to be >= 0
      expect(catalogue.weight).to be <= 10
      catalogue.weight = -1
      expect(catalogue).not_to be_valid
      expect(catalogue.errors[:weight]).to include("must be greater than or equal to 0")
      catalogue.weight = 11
      expect(catalogue).not_to be_valid
      expect(catalogue.errors[:weight]).to include("must be less than or equal to 10")
    end

    it 'checks whether manfacture date is greater than today date' do
      catalogue.manufacture_date = Date.today + 1
      expect(catalogue).not_to be_valid
      expect(catalogue.errors[:manufacture_date]).to include("can't be future dates.")
    end

    it 'should have atleast one image' do
      catalogue.attachments = []
      catalogue.save
      expect(catalogue).not_to be_valid
      expect(catalogue.errors["base"]).to include("must add at least one image")
    end

  end

  context "respond to a method" do
    it 'confirms that an object can respond to a method ' do
      expect(catalogue).to respond_to(:active?, :on_sale?)
      expect(catalogue).to respond_to(:has_images)
      expect(catalogue).to respond_to(:has_remained_any_image_on_update)
      expect(catalogue).to respond_to(:duplicate_variant)
      expect(catalogue).to respond_to(:check_sale_price)
      expect(catalogue).to respond_to(:validate_manufacture_date)
    end
  end
end
