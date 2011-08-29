class Track

  attr_accessor :id
  attr_accessor :filename
  attr_accessor :artist
  attr_accessor :album
  attr_accessor :title
  attr_accessor :track
  attr_accessor :md5_hash

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
        parsed_json.each do |track_info|
          begin
            if track_info.last.is_a?(Hash)
              track = Track.new

              track.filename = track_info.last['filename']
              track.artist   = track_info.last['artist']
              track.album    = track_info.last['album']
              track.title    = track_info.last['title']
              track.track    = track_info.last['track']
              track.md5_hash = track_info.last['md5_hash']
              track.id       = index.track_info.first

              tracks << track
            end
          rescue Exception => e
            Rails.logger.error "Error: #{track_info.inspect} #{e}"
          end
        end
      end

      Rails.cache.write(Track::TRACKS_CACHE_KEY, tracks)
      tracks
    end

    def search(phrase)
      regex = /#{phrase}/i
      tracks = Track.tracks
      search_result = tracks.select do |track|
        begin
          track &&
            (regex =~ track.filename ||
              regex =~ track.artist ||
              regex =~ track.album ||
              regex =~ track.title)
        rescue Exception => e
          Rails.logger.error "Error: #{e}"
          nil
        end
      end

      search_result || []
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

  # TODO: This method is a mess. Need to sort it out
  def display_name
    return @display_name if @display_name
    name = []
    name << album
    name << artist

    unless name.select(&:present?).empty?
      name << (title.present? ? title : filename.split('/').last)
    else
      name << title
    end

    name = name.select(&:present?)

    @display_name = name.empty? ? filename : name.insert(0, track).join(' - ')
    @display_name
  end

end

