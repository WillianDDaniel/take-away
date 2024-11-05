class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :menuable, polymorphic: true
end
