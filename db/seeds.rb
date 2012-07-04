# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: "admin@admin.com", password: "admin123", password_confirmation: "admin123")
Admin.create!(user_id: User.first)
Group.create!(name: "Public", user_id: User.first, status: "open", description: "Opne group")
GroupMember.create!(group_id: Group.first, user_id: User.first, role: "admin")