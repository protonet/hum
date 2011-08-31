class List

  TRACKS_LIST_KEY = "TRACKS_LIST_KEY"

  class << self

    def add(track_hash)
      queue = list
      queue << track_hash
      Rails.cache.read(Queue::TRACKS_QUEUE_KEY, queue)
    end

    def clear
      Rails.cache.write(Queue::TRACKS_QUEUE_KEY, [])
    end

    def list
      Rails.cache.read(Queue::TRACKS_QUEUE_KEY) || []
    end

  end

end

