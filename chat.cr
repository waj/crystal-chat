require "socket"
require "./server"
require "./client"

server_socket = TCPServer.new(5000)
server = Server.new

puts "Esperando conexiones..."
loop do
  socket = server_socket.accept
  spawn handle_client(server, socket)
end

def handle_client(server, socket)
  socket.puts "===== Bienvenido! ====="
  socket.print "Ingrese su nombre: "
  name = socket.gets

  if name
    name = name.chomp
    client = Client.new(socket, name)
    server.add_client client
    client.handle server
  end
end
