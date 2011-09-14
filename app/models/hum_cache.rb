class HumCache

  class << self

    def read(key)
      json = AppCache.get(key)
      json.nil? || json == 'null' ? nil : JSON.parse(json)
    end

    def write(key, value)
      AppCache.set key, value.to_json
    end

  end

end
