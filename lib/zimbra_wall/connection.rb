module ZimbraWall
  class Connection

    attr_accessor :headers, :body, :started, :done, :buffer

    def initialize
      @headers = nil
      @body = ""
      @started = false
      @done = false
      @buffer = ''
    end

    def self.parse_lookup_response(resp)
      array = resp.split("\r\n")
      array.push("")
      hash = {}
      array[1..-1].each do |h|
        tmp = h.split(/: /)
        hash[tmp[0]] = tmp[1]
      end
      hash
    end

  end
end
