require 'watir' # Crawler
require 'pry' # Ruby REPL
require 'rb-readline' # Ruby IRB
require 'awesome_print' # Console output
require_relative 'credentials' # Pulls in login credentials from credentials.rb

username = $username
password = $password
users = ['katyperry', 'jlo', 'ddlovato', 'kourtneykardash', 'victoriasecret', 'badgalriri', 'fcbarcelona', 'realmadrid', 'theellenshow', 'justintimberlake', 'zendaya' 'caradelevingne', '9gag', 'chrisbrownofficial', 'vindiesel']
follow_counter = 0
unfollow_counter = 0
MAX_UNFOLLOWS = 10000
start_time = Time.now

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']
browser.goto "instagram.com/accounts/login/"

# Navigate to Username and Password fields, inject info
puts "Logging in..."
browser.text_field(:name => "username").set "#{username}"
browser.text_field(:name => "password").set "#{password}"

# Click Login Button
browser.button(:class => '_qv64e _gexxb _4tgw8 _njrw0').click
sleep(2)
puts "We're in #hackerman"

# Continuous loop to run until you've unfollowed the max people for the day
loop do
    users.each { |val|
        # Navigate to user's page
        browser.goto "instagram.com/#{val}/"
        
        # If not following then follow
        if browser.button(:class => '_qv64e _gexxb _r9b8f _njrw0').exists?
            ap "Following #{val}"
            browser.button(:class => '_qv64e _gexxb _r9b8f _njrw0').click
            follow_counter += 1
            elsif browser.button(:class => '_qv64e _t78yp _r9b8f _njrw0').exists?
            ap "Unfollowing #{val}"
            browser.button(:class => '_qv64e _t78yp _r9b8f _njrw0').click
            unfollow_counter += 1
        end
        sleep(1.0/2.0) # Sleep half a second to not get tripped up when un/following many users at once
    }
    puts "--------- #{Time.now} ----------"
    break if unfollow_counter >= MAX_UNFOLLOWS
    sleep(60.0) # Sleep 1 hour (3600 seconds)
end

ap "Followed #{follow_counter} users and unfollowed #{unfollow_counter} in #{((Time.now - start_time)/60).round(2)} minutes"

# Leave this in to use the REPL at end of program
# Otherwise, take it out and program will just end
Pry.start(binding)


