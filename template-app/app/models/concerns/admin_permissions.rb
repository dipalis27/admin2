module AdminPermissions
  extend ActiveSupport::Concern

  PERMISSION_KEYWORDS = [
    ['product','BxBlockCatalogue::Catalogue'],
    ['category','BxBlockCategoriesSubCategories::Category'],
    ['order', 'BxBlockOrderManagement::Order'],
    ['brand', 'BxBlockCatalogue::Brand'],
    ['coupon', 'BxBlockCouponCodeGenerator::CouponCode'],
    ['tag', 'BxBlockCatalogue::Tag'],
    ['user', 'AccountBlock::Account'],
    ['brand setting', 'BxBlockStoreProfile::BrandSetting'],
    ['tax', 'BxBlockOrderManagement::Tax'],
    ['variant', 'BxBlockCatalogue::Variant'],
    ['email setting', 'BxBlockSettings::EmailSetting'],
    ['bulk upload', 'BxBlockCatalogue::BulkImage']
  ]

  # Add routes inside this as per permissions to give access to sub admin
  PERMISSION_ROUTES = HashWithIndifferentAccess.new({
    'bx_block_admin/v1/catalogues': 'BxBlockCatalogue::Catalogue',
    'bx_block_admin/v1/categories': 'BxBlockCategoriesSubCategories::Category',
    'bx_block_admin/v1/order_reports': 'BxBlockOrderManagement::Order',
    'bx_block_admin/v1/orders': 'BxBlockOrderManagement::Order',
    'bx_block_admin/v1/brands': 'BxBlockCatalogue::Brand',
    'bx_block_admin/v1/coupon_codes': 'BxBlockCouponCodeGenerator::CouponCode',
    'bx_block_admin/v1/tag': 'BxBlockCatalogue::Tag', #valid route needed
    'bx_block_admin/v1/customers': 'AccountBlock::Account',
    'bx_block_admin/v1/brand_settings': 'BxBlockStoreProfile::BrandSetting',
    'bx_block_admin/v1/taxes': 'BxBlockOrderManagement::Tax',
    'bx_block_admin/v1/variants': 'BxBlockCatalogue::Variant',
    'bx_block_admin/v1/email_settings': 'BxBlockSettings::EmailSetting',
    'bx_block_admin/v1/bulk_uploads': 'BxBlockCatalogue::BulkImage'
  })

  PERMISSION_CONVERSIONS = HashWithIndifferentAccess.new({
    'BxBlockCatalogue::Catalogue': 'product',
    'BxBlockCategoriesSubCategories::Category': 'category',
    'BxBlockOrderManagement::Order': 'order',
    'BxBlockCatalogue::Brand': 'brand',
    'BxBlockCouponCodeGenerator::CouponCode': 'coupon',
    'BxBlockCatalogue::Tag': 'tag',
    'AccountBlock::Account': 'user',
    'BxBlockStoreProfile::BrandSetting': 'brand setting',
    'BxBlockOrderManagement::Tax': 'tax',
    'BxBlockCatalogue::Variant': 'variant',
    'BxBlockSettings::EmailSetting': 'email setting',
    'BxBlockCatalogue::BulkImage': 'bulk upload'
  })

  PERMISSIONS = [
    'BxBlockCatalogue::Catalogue', 'BxBlockCategoriesSubCategories::Category',
    'BxBlockOrderManagement::Order', 'BxBlockCatalogue::Brand',
    'BxBlockCouponCodeGenerator::CouponCode', 'BxBlockCatalogue::Tag',
    'AccountBlock::Account', 'BxBlockStoreProfile::BrandSetting',
    'BxBlockOrderManagement::Tax', 'BxBlockCatalogue::Variant',
    'BxBlockSettings::EmailSetting', 'BxBlockCatalogue::BulkImage'
  ]
end
