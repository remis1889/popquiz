class Survey < ApplicationRecord
  has_many :mcqs, -> { includes :options }, dependent: :destroy
  has_many :nrqs, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :answers, through: :responses

  validates :title, presence: true, uniqueness: true

  attr_accessor :question_type
  QUESTION_TYPES = ['Multiple Choice', 'Number Range'].freeze

  def questions?
    (mcqs.any? || nrqs.any?)
  end

  def result_count
    results = {}
    answers.group_by { |a| [a.question_id, a.answer_entry, a.question_type] }
           .map { |k, v| results[k] = v.length }
    results
  end

  def question_details
    questions = {}
    mcqs.map { |m| questions[[m.id, 'Mcq']] = { question_text: m.question_text, required: m.required, multiselect: m.multiselect, options: m.options } }
    nrqs.map { |n| questions[[n.id, 'Nrq']] = { question_text: n.question_text, required: n.required, min: n.min, max: n.max } }
    questions
  end
end
