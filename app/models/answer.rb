class Answer < ApplicationRecord
  belongs_to :question, polymorphic: true
  belongs_to :response, optional: true
  validates :answer_entry,
            presence: { message: 'You must select at least one option below' }, if: :required_question?

  attr_accessor :checked

  def required_question?
    question.required
  end
end
