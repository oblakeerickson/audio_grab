require_relative 'audio_grab'

begin
  if ARGV.empty?
    exit 0
  end
  url = ARGV[0]
  audio_grab = AudioGrab.new
  audio_grab.download_and_convert_video(url)
  file = audio_grab.mp3_file
  audio_grab.upload_to_overcast(file)
  audio_grab.move_to_uploaded(file)
rescue Exception => e
  puts e.message
end
