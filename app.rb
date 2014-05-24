require "bundler/setup"
require "dotenv"
require "pp"
Dotenv.load

require "twitter"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end

puts "Fetching ..."

followers = []
client.follower_ids.to_h[:ids].each_slice(100) do |ids|
  followers.concat client.users(ids)
end

sorted_list = followers.sort_by {|follower| follower.followers_count.to_i }
sorted_list.reverse!

sorted_list.map {|u| u.screen_name }

open("list.csv", "w") do |f|
  sorted_list.each do |u|
    f.puts "#{u.name},#{u.screen_name},#{u.followers_count}"
  end
end
