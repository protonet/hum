class List

  TRACKS_LIST_KEY = "TRACKS_LIST_KEY"

  class << self

    def add(id)
      queue = list
      queue = [id] + queue
      Rails.cache.write(List::TRACKS_LIST_KEY, queue)
    end

    def clear
      Rails.cache.write(List::TRACKS_LIST_KEY, [])
    end

    def list
      Rails.cache.read(List::TRACKS_LIST_KEY) || []
    end

  end

end

