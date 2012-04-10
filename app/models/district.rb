class District < ActiveRecord::Base
  belongs_to :province
  has_many :candidates
  has_many :divisions
  has_many :regions, :through => :divisions
end
