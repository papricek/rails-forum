FactoryGirl.define do

  factory :forum do
    title
    description { generate(:text) }
  end

  factory :group do
    name
  end

  factory :topic do
    subject { generate(:title) }
    forum
    user

    trait :approved do
      state 'approved'
    end

    factory :approved_topic, :traits => [:approved]
  end

  factory :post do
    text
    user
    trait :approved do |post|
      post.state 'approved'
    end

    factory :approved_post, :traits => [:approved]
  end

  factory :user do |f|
    name
    nick { generate(:name) }
    email
    password "password"
    password_confirmation "password"
    auto_subscribe true

    factory :admin do
      admin true
    end

    factory :not_autosubscribed do
      auto_subscribe false
    end
  end

  sequence :email do |n|
    Faker::Internet.email
  end

  sequence :name do |n|
    (Faker::Name.name + n.to_s).gsub("'", '')
  end

  sequence :title do |n|
    Faker::Lorem.words(5).join(" ").capitalize
  end

  sequence :text do |n|
    Faker::Lorem.paragraph
  end

end
