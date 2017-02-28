class Mcq < ApplicationRecord
  has_many :options, dependent: :destroy
  has_many :answers, as: :question, dependent: :destroy
  belongs_to :survey

  attr_writer :current_step
  attr_accessor :option_count

  accepts_nested_attributes_for :options
  validates :question_text, presence: true

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[setup options]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def last_step?
    current_step == steps.last
  end
end
