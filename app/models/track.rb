class Track

  include DataMapper::Resource

  property :id,       Serial
  property :index_number, String, :index => true
  property :filename,     Text
  property :artist,       String, :length => 0..255
  property :album,        String, :length => 0..255
  property :title,        String, :length => 0..255

  class << self
    def fetch_tracks
      File.open(tracks_file, 'w') do |file|
        parsed_json = JSON.parse(HumConfig.get_listing)
        file.write(parsed_json.to_json)
      end
    end

    def load_tracks
      fetch_tracks unless File.exist?(tracks_file)
      json_contents = ""
      tracks = []

      File.open(tracks_file, 'r') do |file|
        json_contents = file.read

        parsed_json = JSON.parse(json_contents)

        parsed_json.each do |index, track_info|
          begin
            track = Track.new
            track.index_number = index.to_s
            track.filename     = track_info['filename']
            track.artist       = track_info['artist']
            track.album        = track_info['album']
            track.title        = track_info['title']
            tracks << track
          rescue Exception => e
            puts "Error: #{track_info.inspect} #{e}"
          end
        end
      end

      repository(:default).adapter.select('DELETE FROM tracks')

      start_time =  Time.now
      tracks.each_with_index do |track,index|
        begin
          track.save
          puts "Track save #{index}"
        rescue Exception => e
          puts "Error #{e}"
        end
      end
      end_time = Time.now
      puts "TIME: #{start_time} --> #{end_time}"
    end

    def tracks_file
      @tracks_file ||= "#{Rails.root}/tmp/tracks.json"
    end
  end

end
