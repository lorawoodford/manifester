# SITE
class Site
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
  field :username
  field :password
end
