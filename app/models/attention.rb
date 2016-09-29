class Attention < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :currency, :target_amount
  validates_numericality_of :target_amount
end
