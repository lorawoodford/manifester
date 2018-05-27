# SITE
class Site
  include Dynamoid::Document

  table name:           :sites,
        key:            :site_id,
        read_capacity:  1,
        write_capacity: 1

  has_many :files

  field :site
  field :manifest
  field :name
  field :contact
  field :email
  field :timezone
  field :status, :integer, default: 200
  field :username
  field :password
end
