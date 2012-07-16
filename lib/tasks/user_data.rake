namespace :db do
  def rand_in_range(from, to)
    rand * (to - from) + from
  end

  desc "Fill database with sample data"
  task populate_users: :environment do
    puts "creating users"
    20.times do |n| #create users
      email  = Faker::Internet.email
      password  = "password"
      u = User.create!(email: email,
                   password: password,
                   password_confirmation: password)
      GroupMember.create!(user_id: u.id, group_id: Group.first.id, role: "student")
    end
  end
  task populate_teachers: :environment do
    puts "creating teachers"
    2.times do |n| #create users
      email  = Faker::Internet.email
      password  = "password"
      u = User.create!(email: email,
                   password: password,
                   password_confirmation: password)
      GroupMember.create!(user_id: u.id, group_id: Group.first.id, role: "teacher")
    end
  end  
  task populate_posts: :environment do
    puts "creating posts"
    100.times do |n| #random user creates posts in the first group (Public)
      u = rand(1..User.count)
      t = Faker::Lorem.paragraph(1)
      c = Faker::Lorem.paragraph(rand(10..100))
      p = Post.create(user_id: u, group_id: Group.first, title: t, content: c)
      p.created_at = (rand*14+15).days.ago #random created_at
      p.updated_at = (rand*14).days.ago #random updated at
      p.save!
    end
  end
  task populate_comments: :environment do
    puts "creating comments"
    100.times do |n| #random user comments on a random post
      u = rand(1..User.count)
      p_id = rand(1..Post.count)
      c = Faker::Lorem.paragraph(rand(5..50))
      user_comment = Comment.create(user_id: u, post_id: p_id, content: c)
      user_comment.created_at = Time.at(rand_in_range(Post.find(p_id).created_at.to_f, Time.now.to_f))
      user_comment.save!
    end
  end
  task populate_tags: :environment do
    puts "creating tags"
    common_tags = Faker::Lorem.words(5)
    average_tags = Faker::Lorem.words(10)
    rare_tags = Faker::Lorem.words(30)
    tag_words = []
    for tag in common_tags
      tag_words << [tag]*20
    end
    for tag in average_tags
      tag_words << [tag]*5
    end
    for tag in rare_tags
      tag_words << [tag]
    end
    tag_words = tag_words.flatten    
    100.times do |n| #random user tags random post with word from tag list
      u = User.find(rand(1..User.count))
      p = Post.find(rand(1..Post.count))
      t = tag_words.sample()
      new_tags = p.tags_from(u).append(t).join(',')
      u.tag(p, with: new_tags, on: :tags) #don't care about when
    end
  end
  task populate_blurts: :environment do
    puts "creating blurts"
    100.times do |n| #random blurts
      u = User.find(rand(1..User.count))
      c = Faker::Lorem.sentence()
      b = u.blurts.build(content: c[0..139])
      b.created_at = (rand*28).days.ago #random created_at
      b.updated_at = b.created_at
      b.save!
    end
  end
  task populate_friendships: :environment do
    10.times do |n|
      u = User.find(rand(1..User.count)) 
      f = User.find(rand(1..User.count))
      if u.id != f.id
        u.follow!(f)
      end
    end
  end

end