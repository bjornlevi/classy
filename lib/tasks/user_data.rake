namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #User.create!(email: "bjornlevi@gmail.com",
    #             password: "foobar",
    #             password_confirmation: "foobar")
    99.times do |n|
      email  = Faker::Internet.email
      password  = "password"
      User.create!(email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end