# coding: utf-8
require 'rexml/document' 
require 'mechanize'
require 'twitter'

settings = REXML::Document.new(open('./settings/settings.xml'))

YOUR_CONSUMER_KEY = settings.elements['root/twitter/consumerKey'].text
YOUR_CONSUMER_SECRET = settings.elements['root/twitter/consumerSecret'].text
YOUR_ACCESS_TOKEN = settings.elements['root/twitter/accessToken'].text
YOUR_ACCESS_TOKEN_SECRET = settings.elements['root/twitter/accessTokenSecret'].text

reg = /.*<div class="result2">[\s\t\n]*<div style="text-align:center;">[\s\t\n]*(.*?)[\s\t\n]*<div>[\s\t\n]*<\/div>.*/

agent = Mechanize.new

page = agent.get('http://shindanmaker.com/525631')

form = page.forms[0]
form.field_with(:name => "u").value = rand
button = form.button_with(:id => "shindan_submit")
result = agent.submit(form,button)
result.body.force_encoding('utf-8')

result.body.match(reg) do |m|
  puts m[1]
  rest = Twitter::REST::Client.new do |config|
    config.consumer_key = YOUR_CONSUMER_KEY
    config.consumer_secret = YOUR_CONSUMER_SECRET
    config.access_token = YOUR_ACCESS_TOKEN
    config.access_token_secret = YOUR_ACCESS_TOKEN_SECRET
  end
  str = "やーい" + m[1] + "w"
  rest.update(str)
end
