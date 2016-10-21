class User < ActiveRecord::Base
  belongs_to :company
  has_one :profile
end
