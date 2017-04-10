module HttpEventstore
  class Endpoint
    def initialize(scheme, endpoint, port)
      @scheme = scheme
      @endpoint = endpoint
      @port = port
    end

    def url
      "#{scheme}://#{endpoint}:#{port}"
    end

    private

    attr_reader :scheme, :endpoint, :port
  end
end
