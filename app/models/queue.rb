class Queue

  TRACKS_QUEUE_KEY = "TRACKS_QUEUE_KEY"

  class << self

    def add(id)
      queue = list
      queue = queue + [id]
      Rails.cache.write(Queue::TRACKS_QUEUE_KEY, queue)
    end

    def remove
      queue = list
      id = queue[0]
      queue = queue.slice(1,queue.size - 1)
      Rails.cache.write(Queue::TRACKS_QUEUE_KEY, queue)
      id
    end

    def list
      Rails.cache.read(Queue::TRACKS_QUEUE_KEY) || []
    end

  end

end

