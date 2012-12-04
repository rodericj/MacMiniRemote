require "webrick"
require "rubygems"
require "json"

include WEBrick


def start_webrick(config = {})
  config.update(:Port => 9955)
  server = HTTPServer.new(config)
  yield server if block_given?
  ['INT', 'TERM'].each {|signal| 
    trap(signal) {server.shutdown}
  }
  server.start
end

class Shows < HTTPServlet::AbstractServlet
    def do_GET(req,resp)
      resp.body = JSON.generate(['Modern Family', 'Simpsons'])
      raise HTTPStatus::OK
    end
end

class ModernFamily < HTTPServlet::AbstractServlet
    def do_GET(req,resp)
        system "say hello"
	raise HTTPStatus::OK
    end
end

start_webrick { | server |
  server.mount('/', Shows)
  server.mount('/ModernFamily', ModernFamily)
}

