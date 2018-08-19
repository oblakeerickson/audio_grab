require 'mechanize'
require 'fileutils'
require 'yaml'

class AudioGrab
  def initialize
    @config = YAML.load_file('config.yml')
  end

  def download_and_convert_video(url)
    system "youtube-dl -o 'process/%(title)s.%(ext)s' --restrict-filenames --extract-audio --audio-format mp3 #{url}"
  end

  def files
    Dir["process/*.mp3"]
  end

  def mp3_file
    self.files[0]
  end

  def upload_to_overcast(file)
    a = Mechanize.new
    
    login_page = a.get('https://overcast.fm/login')
    
    my_page = login_page.form do |form|
      form.email = @config['overcast_username']
      form.password = @config['overcast_password']
    end.submit
    
    upload_page = a.click(my_page.link_with(:text => /ploads/))
    
    upload_page.form_with(:method => 'POST') do |upload_form|
      upload_form.file_uploads.first.file_name = file
    end.submit
  end

  def move_to_uploaded(file)
    FileUtils.mv(file, "uploaded/#{File.basename(file)}")
  end
end

