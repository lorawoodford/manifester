# FILE
class ManifestFile
  include Dynamoid::Document

  table name:           :files,
        key:            :file_id,
        range_key:      :timestamp,
        read_capacity:  1,
        write_capacity: 1

  field :site
  field :url
  field :filename
  field :title
  field :deleted, :boolean, default: false, store_as_native_boolean: true
  field :timestamp, :integer
  field :status, :integer, default: 200
  field :type, :string # base key for sorting

  validates_presence_of :site, :timestamp
end
