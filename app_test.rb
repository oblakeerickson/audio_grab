require 'minitest/autorun'
require_relative 'app'
require 'fileutils'

class AudioGrabTest < Minitest::Test
  def test_download_and_convert_video
    url = "https://www.youtube.com/watch?v=uyheh7elnaU"
    audio_grab = AudioGrab.new
    audio_grab.download_and_convert_video(url)
    assert_operator audio_grab.files.length, :>, 0
  end

  def test_mp3_file
    url = "https://www.youtube.com/watch?v=uyheh7elnaU"
    audio_grab = AudioGrab.new
    audio_grab.download_and_convert_video(url)
    assert_equal audio_grab.mp3_file, "process/How_Many_Views_Can_This_1_Second_Video_Get.mp3"
  end

  def teardown
    FileUtils.rm_rf("process/.", secure: true)
  end
end
