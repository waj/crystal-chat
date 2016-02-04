class Client
  getter name

  def initialize(@socket, @name)
  end

  def handle(server)
    begin
      until @socket.closed?
        message = @socket.gets
        break unless message
        server.send_text self, message.chomp
      end
    rescue IO::Error
    end

    server.remove_client self
    @socket.close
  end

  def close
    @socket.close
  end

  def send(message)
    @socket.puts message
  end
end
