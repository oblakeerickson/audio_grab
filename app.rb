require 'mechanize'
require 'fileutils'
require 'yaml'

config = YAML.load_file('config.yml')

# from the command line read:
# 1. read youtube video url param
# 2. use youtube-dl to download and convert it to mp3
# 3. upload to overcast
#

Dir.mkdir("process") unless File.exists?("process")
Dir.mkdir("uploaded") unless File.exists?("uploaded")

url = ARGV[0]

system "youtube-dl -o 'process/%(title)s.%(ext)s' --restrict-filenames --extract-audio --audio-format mp3 #{url}"

files = Dir["process/*.mp3"]
file = files[0]

a = Mechanize.new

login_page = a.get('https://overcast.fm/login')

my_page = login_page.form do |form|
  form.email = config['overcast_username']
  form.password = config['overcast_password']
end.submit

upload_page = a.click(my_page.link_with(:text => /ploads/))

upload_page.form_with(:method => 'POST') do |upload_form|
  upload_form.file_uploads.first.file_name = file
end.submit

FileUtils.mv(file, "uploaded/#{File.basename(file)}")
