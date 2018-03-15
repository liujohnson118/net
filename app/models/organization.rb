class Organization < ApplicationRecord
  validates :name, length: {minimum:1, maximum:30}, uniqueness: { case_sensitive: false }
  validates :subdomain, length: {minimum:1,maximum:30}, uniqueness: {case_sensitive: false}
  after_create :create_tenant

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end
end
