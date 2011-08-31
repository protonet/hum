class Queue

  TRACKS_QUEUE_KEY = "TRACKS_QUEUE_KEY"

  class << self

    def add(track_hash)
      queue = list
      queue << track_hash
      Rails.cache.write(Queue::TRACKS_QUEUE_KEY, queue)
    end

    def remove
      queue = list
      track_hash = queue.delete_at(0)
      Rails.cache.write(Queue::TRACKS_QUEUE_KEY, queue)
      track_hash
    end

    def list
      Rails.cache.read(Queue::TRACKS_QUEUE_KEY) || []
    end

  end

end

