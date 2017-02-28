class Nrq < ApplicationRecord
  belongs_to :survey
  has_many :answers, as: :question, dependent: :destroy

  validates :question_text, presence: true
end
