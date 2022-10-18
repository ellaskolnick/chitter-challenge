require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds/posts_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do
    reset_posts_table
  end

  context "all posts" do
    it "retuns all the posts in anti chronological order" do
      repo = PostRepository.new

      posts = repo.all
      order = posts.first.time_posted > posts.last.time_posted

      expect(posts.length).to eq 7

      expect(posts[0].id).to eq 7
      expect(posts[0].content).to eq 'you really know how to make me cry'
      expect(posts[0].time_posted).to eq '2022-10-21 00:29:00'
      expect(posts[0].user_id).to eq 3
      expect(order).to eq true
    end
  end

  context "add post" do
    it "adds a post and returns the list" do
      repo = PostRepository.new

      post = Post.new
      post.content = "you know it's not the same"
      post.time_posted = '2022-12-08 09:30:00'
      post.user_id = '1'

      repo.create(post)

      posts = repo.all
      expect(posts.length).to eq 8
      expect(posts.first.id).to eq 8
      expect(posts.first.content).to eq "you know it's not the same"
      expect(posts.first.time_posted).to eq '2022-12-08 09:30:00'
      expect(posts.first.user_id).to eq 1
    end
  end
end