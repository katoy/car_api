class Api::V1::CarSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :year
end
