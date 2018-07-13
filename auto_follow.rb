require 'watir' # Crawler
require 'pry' # Ruby REPL
require "open-uri"
require "nokogiri"
require 'awesome_print' # Console output
require_relative "credentials"

username = $username
password = $password
hashtags = "#love, #instagood, #photooftheday, #fashion, #beautiful, #happy, #cute, #tbt, #like4like, #followme, #picoftheday, #follow, #me, #selfie, #summer, #art, #instadaily, #friends, #repost, #nature, #girl, #fun, #style, #smile, #food, #instalike, #likeforlike, #family, #travel, #fitness, #igers, #tagsforlikes, #follow4follow, #nofilter, #life, #beauty, #amazing, #instamood, #instagram, #photography, #vscocam, #sun, #photo, #music, #beach, #followforfollow, #bestoftheday, #sky, #ootd, #sunset, #dog, #vsco, #l4l, #makeup, #f4f, #foodporn, #hair, #pretty, #swag, #cat, #model, #motivation, #girls, #baby, #party, #cool, #lol, #gym, #design, #instapic, #funny, #healthy, #night, #tflers, #yummy, #flowers, #lifestyle, #hot, #instafood, #wedding, #fit, #handmade, #black, #pink, #일상, #blue, #work, #workout, #blackandwhite, #drawing, #inspiration, #home, #holiday, #christmas, #nyc, #london, #sea, #instacool, #goodmorning, #iphoneonly"
hashtag_list = hashtags.split(", ")

users = ['katyperry', 'jlo', 'ddlovato', 'kourtneykardash', 'victoriasecret', 'badgalriri', 'fcbarcelona', 'realmadrid', 'theellenshow', 'justintimberlake', 'zendaya' 'caradelevingne', '9gag', 'chrisbrownofficial', 'vindiesel']
follow_counter = 0
unfollow_counter = 0
MAX_UNFOLLOWS = 10000
start_time = Time.now

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']
browser.goto "instagram.com/accounts/login/"

# Navigate to Username and Password fields, inject info

puts "Logging in...#{username} & #{password}"
puts browser.text_field(:name => "username").name
puts username.class
Pry.start
# browser.text_field(:name => "username").set(username)

# browser.text_field(:name => "password").set(password)

puts "Logged in"
# Click Login Button
browser.button(:class => '_qv64e _gexxb _4tgw8 _njrw0').click
sleep(2)
puts "We're in #hackerman"

url = "https://www.instagram.com/explore/tags/love/"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

result = []
html_doc.search('href').each do |element|
  result << element.text.strip
end

# Continuous loop to run until you've unfollowed the max people for the day
def crawl
  loop do
      users.each { |val|
          # Navigate to user's page
          browser.goto "instagram.com/#{val}/"

          # If not following then follow
          if browser.button(:class => '_5f5mN       jIbKX  _6VtSN     yZn4P   ').exists?
              ap "Following #{val}"
              browser.button(:class => '_5f5mN       jIbKX  _6VtSN     yZn4P   ').click
              follow_counter += 1
          elsif browser.button(:class => '_5f5mN    -fzfL     _6VtSN     yZn4P   ').exists?
              ap "Unfollowing #{val}"
              browser.button(:class => '_5f5mN    -fzfL     _6VtSN     yZn4P   ').click
              browser.button(:class => 'aOOlW -Cab_   ').click
              unfollow_counter += 1
          end
          sleep(1.0/2.0) # Sleep half a second to not get tripped up when un/following many users at once
      }
      puts "--------- #{Time.now} ----------"
      break if unfollow_counter >= MAX_UNFOLLOWS
      sleep(10.0) # Sleep 1 hour (3600 seconds)
  end
end
ap "Followed #{follow_counter} users and unfollowed #{unfollow_counter} in #{((Time.now - start_time)/60).round(2)} minutes"

# Leave this in to use the REPL at end of program
# Otherwise, take it out and program will just end
Pry.start(binding)


