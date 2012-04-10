class Region < ActiveRecord::Base
  belongs_to :province
  has_many :divisions
  has_many :districts, :through => :divisions
end
