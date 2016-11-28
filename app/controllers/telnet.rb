require 'net/telnet'

class Telnet

  def connect(ip, port)

    service = '?'

    begin
      host = Net::Telnet::new(
          "Host"       => ip,  # default: "localhost"
          "Port"       => port,           # default: 23
          "Binmode"    => false,        # default: false
          "Output_log" => "output_log", # default: nil (no output)
          "Dump_log"   => "dump_log",   # default: nil (no output)
          "Prompt"     => /[$%#>] \z/n, # default: /[$%#>] \z/n
          "Telnetmode" => true,         # default: true
          "Timeout"    => 10,           # default: 10
          # if ignore timeout then set "Timeout" to false.
          "Waittime"   => 0            # default: 0
      # proxy is Net::Telnet or IO object
      )

      response = host.cmd('lala')

    rescue Net::ReadTimeout
      service = '-'
    end

    if response == nil
      puts "\n\nresponse is nil\n\n"
    elsif response.downcase.include? 'ssh'
      service = 'SSH'
    elsif response.downcase.include? 'http'
      service = 'http'
    end

    service

  end



end