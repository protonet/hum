class Track

  attr_accessor :filename
  attr_accessor :artist
  attr_accessor :album
  attr_accessor :title

  TRACKS_CACHE_KEY = "TRACKS_CACHE_KEY"

  class << self

    def tracks_loaded?
      Rails.cache.read(Track::TRACKS_CACHE_KEY).nil?
    end

    def tracks
      Rails.cache.read(Track::TRACKS_CACHE_KEY) || []
    end

    def fetch_tracks
      ensure_tmp

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

            track.filename = track_info['filename']
            track.artist   = track_info['artist']
            track.album    = track_info['album']
            track.title    = track_info['title']

            tracks.insert(index.to_i, track)
          rescue Exception => e
            puts "Error: #{track_info.inspect} #{e}"
          end
        end
      end

      Rails.cache.write(Track::TRACKS_CACHE_KEY, tracks)
      tracks
    end


    def ensure_tmp
      unless File.exist?(tmp_dir)
        require 'fileutils'
        FileUtils.mkdir_p (tmp_dir)
      end
    end

    def tmp_dir
      @tmp_dir ||= "#{Rails.root}/tmp"
    end

    def tracks_file
      @tracks_file ||= "#{tmp_dir}/tracks.json"
    end

  end

end
