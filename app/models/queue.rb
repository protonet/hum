class Queue

  TRACKS_QUEUE_KEY = "TRACKS_QUEUE_KEY"

  class << self

    def add(id, key_uniqueifier = nil)
      queue = list(key_uniqueifier)
      queue = queue + [id]
      HumCache.write(cache_key(key_uniqueifier), queue)
    end

    def remove(key_uniqueifier = nil)
      queue = list(key_uniqueifier)
      id = queue[0]
      queue = queue.slice(1,queue.size - 1)
      HumCache.write(cache_key(key_uniqueifier), queue)
      id
    end

    def list(key_uniqueifier = nil)
      HumCache.read(cache_key(key_uniqueifier)) || []
    end

    def cache_key(key_uniqueifier = nil)
      key = "#{Queue::TRACKS_QUEUE_KEY}"
      key += "-#{key_uniqueifier}" if key_uniqueifier
      key
    end

  end

end

