class HumConfig
  include DataMapper::Resource

  property :id,     Serial
  property :server, String

  class << self

    def conf
      first_or_create
    end

    def get_listing
      request = Typhoeus::Request.new("#{self.conf.server}/listing",
        :method        => :get,
        :headers       => {:Accept => "application/json"},
        :timeout       => 60000, # milliseconds
        :cache_timeout => 60, # seconds
      )

      # Run the request via Hydra.
      hydra = Typhoeus::Hydra.new
      hydra.queue(request)
      hydra.run

      # the response object will be set after the request is run
      response = request.response
      response.code    # http status code
      response.time    # time in seconds the request took
      response.headers # the http headers
      response.headers_hash # http headers put into a hash
      response.body    # the response body
    end

  end

end
