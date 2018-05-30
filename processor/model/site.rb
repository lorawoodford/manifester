# SITE
class ManifestSite
  include Dynamoid::Document

  table name:           :sites,
        key:            :site_id,
        read_capacity:  1,
        write_capacity: 1

  field :site
  field :manifest
  field :name
  field :contact
  field :email
  field :timezone
  field :status, :integer, default: 200
  field :username
  field :password

  validates_presence_of :site, :manifest, :name, :contact, :email, :timezone
  validates_format_of :email, with: /@/
end
