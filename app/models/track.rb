class Track

  attr_accessor :id
  attr_accessor :filename
  attr_accessor :artist
  attr_accessor :album
  attr_accessor :title
  attr_accessor :track
  attr_accessor :genres

  TRACKS_CACHE_KEY           = "TRACKS_CACHE_KEY"
  TRACKS_HASH_MAPPING_KEY    = "TRACKS_HASH_MAPPING_KEY"

  class << self

    def tracks_loaded?
      tracks = Rails.cache.read(Track::TRACKS_CACHE_KEY)
      !tracks.nil? && !tracks.empty?
    end

    def tracks
      Rails.cache.read(Track::TRACKS_CACHE_KEY) || []
    end

    def hash_to_index(id)
      mappings = Track.hash_to_index_mappings
      mappings[id]
    end

    def hash_to_index_mappings
      hash = Rails.cache.read(Track::TRACKS_HASH_MAPPING_KEY) || {}
      if hash.empty?
        tracks.each_with_index do |track, index|
          hash[track.id] = index
        end
        Rails.cache.write(Track::TRACKS_HASH_MAPPING_KEY, hash)
      end
      hash
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
        music_bases = parsed_json['music_bases']
        parsed_json.each do |hash_id, track_info|
          begin
            if track_info.is_a?(Hash)
              track = Track.new

              track.filename = shorten_filename(track_info['filename'], music_bases)
              track.artist   = track_info['artist']
              track.album    = track_info['album']
              track.title    = track_info['title']
              track.track    = track_info['track']
              track.genres   = track_info['genres']
              track.id       = hash_id

              tracks << track
            end
          rescue Exception => e
            puts "Error: #{track_info.inspect} #{e}"
            Rails.logger.error "Error: #{track_info.inspect} #{e}"
          end
        end
      end

      tracks = tracks.sort{|a,b| a.filename <=> b.filename}

      puts "Tracks Cached #{Rails.cache.write(Track::TRACKS_CACHE_KEY, tracks)}"
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

    def shorten_filename(filename, m_bases = nil)
      music_bases = m_bases.nil? ? music_bases = Track.tracks['music_bases'] : m_bases

      music_bases.each{|music_base| filename = filename.gsub(music_base,'')}

      filename
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

    return name.empty? ? Track.shorten_filename(filename) : name.insert(0, track).join(' - ')
  end

end

