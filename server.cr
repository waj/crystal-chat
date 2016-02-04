record Message, op, sender, text

class Server
  def initialize
    @inbox = Channel(Message).new
    @clients = [] of Client
    spawn { run }
  end

  def add_client(client)
    @inbox.send Message.new(:add_client, client, nil)
  end

  def remove_client(client)
    @inbox.send Message.new(:remove_client, client, nil)
  end

  def send_text(client, text)
    @inbox.send Message.new(:text, client, text)
  end

  def run
    loop do
      message = @inbox.receive
      case message.op
      when :text
        case message.text
        when "/who"
          message.sender.send @clients.map(&.name as String).join(", ")
        when "/quit"
          message.sender.close
        else
          broadcast message.sender, "#{message.sender.name}: #{message.text}"
        end
      when :add_client
        @clients << message.sender
        broadcast message.sender, "#{message.sender.name} ha entrado"
      when :remove_client
        @clients.delete message.sender
        broadcast message.sender, "#{message.sender.name} se ha ido"
      end
    end
  end

  private def broadcast(sender, message)
    @clients.each do |client|
      next if client == sender
      client.send message
    end
  end
end
