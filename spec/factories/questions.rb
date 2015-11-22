# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "Question title #{n}"}
    sequence(:body) { |n| "Question body #{n}"}
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  #trait :has_answers do
  #  after(:create) do |question|
  #    create_list(:answer, 2, question: question)
  #  end

  #end

end
