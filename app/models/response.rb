class Response < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :survey, counter_cache: true

  accepts_nested_attributes_for :answers

  def remove_blanks
    blank_ans = answers.select { |ans| ans[:answer_entry].nil? }
    answers.destroy(blank_ans)
  end

  def sorted_answers
    answers.sort_by(&:question_id)
  end
end
