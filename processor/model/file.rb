# FILE
class File
  include Dynamoid::Document

  table name:           :files,
        key:            :type,
        range_key:      :timestamp,
        read_capacity:  1,
        write_capacity: 1

  field :site
  field :url
  field :title
  field :deleted, :boolean, default: false, store_as_native_boolean: true
  field :timestamp, :integer, range: true
  field :status, :integer, default: 200
  field :type, :string, default: 'ead_xml' # base key for sorting

  validates_presence_of :site, :url, :timestamp
end
