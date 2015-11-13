# coding: utf-8
require 'rexml/document' 
require 'mechanize'

agent = Mechanize.new

settings = REXML::Document.new(open('./settings/settings.xml'))

nesicaCardId = settings.elements['/groovecoaster/id'].text
password = settings.elements['/groovecoaster/pass'].text

login_page = agent.get('https://mypage.groovecoaster.jp/')
login_page.body.force_encoding('utf-8')

form = login_page.forms[0]
form.field_with(:name => "nesicaCardId").value = nesicaCardId 
form.field_with(:name => "password").value = password
button = form.button_with(:value => "認証する")

agent.submit(form,button)

my_music = agent.get('https://mypage.groovecoaster.jp/sp/json/music_list.php')
my_music.body.force_encoding('utf-8')

json = JSON.load(my_music.body)
play_count_list = json['music_list'].map do |music|
  music['play_count']
end
puts "楽曲プレイ総数: " +  play_count_list.inject(:+).to_s


