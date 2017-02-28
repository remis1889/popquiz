class Option < ApplicationRecord
  belongs_to :mcq, optional: true
  validates :option_text, presence: true
end
