# FILE
class File
  include Dynamoid::Document

  table name:           :files,
        key:            :file_id,
        read_capacity:  1,
        write_capacity: 1

  belongs_to :site

  field :url
  field :title
  field :deleted, :boolean, default: false, store_as_native_boolean: true
  field :timestamp
  field :status, :integer, default: 200
end
