# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Destroying existing data...'

Survey.destroy_all
Mcq.destroy_all
Nrq.destroy_all
Option.destroy_all
Response.destroy_all
Answer.destroy_all

puts 'Cleared existing data.'

COUNT = 10

# Create surveys
puts 'Creating surveys...'
COUNT.times do
  Survey.create(title: Faker::Company.catch_phrase, description: Faker::Lorem.paragraph)
end
puts 'Surveys created.'

def rand_boolean
  [true, false].sample
end

def get_question
  Faker::Lorem.sentence.chop + '?'
end

def add_options(mcq_id)
  rand(2..5).times do
    Option.create(option_text: Faker::Lorem.words(rand(2..3)).join(' '), mcq_id: mcq_id)
  end
end

# select random surveys to add questions
def selected_surveys
  Survey.order('RANDOM()').first(COUNT / 2)
end

# Adding questions
puts 'Adding MCQs...'

selected_surveys.each do |survey|
  rand(3..5).times do
    mcq = Mcq.create(question_text: get_question, survey_id: survey.id, multiselect: rand_boolean, required: rand_boolean)
    add_options(mcq.id)
  end
end
puts 'MCQs created.'

puts 'Adding NRQs...'
selected_surveys.each do |survey|
  rand(3..5).times do
    Nrq.create(question_text: get_question, survey_id: survey.id, min: rand(1..5), max: rand(6..10), required: rand_boolean)
  end
end
puts 'NRQs created.'

def rand_options(mcq)
  # select multiple random options if multiselect is true
  option_count = mcq.multiselect ? rand(1..mcq.options.count) : 1
  mcq.options.pluck(:id).sample(option_count)
end

def add_mcq_responses(mcqs, response_id)
  mcqs.each do |m|
    # add a response only if required is true or the question_id is even (random selection)
    next unless m.required || m.id.odd?
    rand_options(m).map { |option| Answer.create(question_id: m.id, question_type: 'Mcq', answer_entry: option, response_id: response_id) }
  end
end

def add_nrq_responses(nrqs, response_id)
  nrqs.each do |n|
    # add a response only if required is true or the question_id is odd (random selection)
    next unless n.required || n.id.even?
    Answer.create!(question_id: n.id, question_type: 'Nrq', answer_entry: rand(n.min..n.max), response_id: response_id)
  end
end

puts 'Adding Responses...'
selected_surveys.each do |survey|
  if survey.questions?
    (rand(1..3) * COUNT).times do
      response = Response.create!(survey_id: survey.id)
      add_mcq_responses(survey.mcqs, response.id)
      add_nrq_responses(survey.nrqs, response.id)
      Survey.increment_counter(:responses_count, survey.id)
    end
  end
end
Survey.find_each { |survey| Survey.reset_counters(survey.id, :responses) }
puts 'Responses created.'

puts 'Seeding Completed!'
