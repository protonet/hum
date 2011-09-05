class List

  TRACKS_LIST_KEY = "TRACKS_LIST_KEY"

  class << self

    def add(id, key_uniqueifier = nil)
      queue = list(key_uniqueifier)
      queue = [id] + queue
      Rails.cache.write(cache_key(key_uniqueifier), queue)
    end

    def clear(key_uniqueifier = nil)
      Rails.cache.write(cache_key(key_uniqueifier), [])
    end

    def list(key_uniqueifier = nil)
      Rails.cache.read(cache_key(key_uniqueifier)) || []
    end

    def cache_key(key_uniqueifier = nil)
      key = "#{List::TRACKS_LIST_KEY}"
      key += "-#{key_uniqueifier}" if key_uniqueifier
      key
    end

  end

end

