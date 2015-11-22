# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com"}
    password '12345678'
    password_confirmation '12345678'



    #factory :user_with_questions do
    #  transient do
    #    questions_count 5
    #  end

    #  after(:create) do |user, evaluator|
    #    create_list(:question_with_answers, evaluator.questions_count,user: user)
    #  end
  end
end

