class Province < ActiveRecord::Base
  has_many :districts
  has_many :regions
end
