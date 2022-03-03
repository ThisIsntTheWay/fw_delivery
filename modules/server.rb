require 'socket'
require_relative 'config'

# ---------------------
# Preliminary
conf = Configurator.new("config.json")
conf.parse

module HTTP_CODES
  OK = 200
  NOT_FOUND = 404
  WHATEVER = 183
end

# To use: status, headers, body = responseNotFound.call({})
responseNotFound = Proc.new do
  [HTTP_CODES::NOT_FOUND, {'Content-Type' => 'text/html'}, ["Resource unknown"]]
end

# ---------------------
# Server 
server = TCPServer.new conf.ListenPort

while session = server.accept
  request = session.gets
  puts request
 
  session.print "HTTP/1.1 #{HTTP_CODES::WHATEVER}\r\n" # 1
  session.print "Content-Type: text/html\r\n" # 2
  session.print "\r\n" # 3
  session.print "Status is: #{HTTP_CODES::WHATEVER}" #4

  session.close
end