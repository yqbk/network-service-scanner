require 'net/ping'
require 'net/telnet'

class ScannerUtils

  def telnet(ip, port)

    service = '?'

    begin
      host = Net::Telnet::new(
          "Host"       => ip,  # default: "localhost"
          "Port"       => port,           # default: 23
          "Binmode"    => false,        # default: false
          "Output_log" => "output_log", # default: nil (no output)
          "Prompt"     => /[$%#>] \z/n, # default: /[$%#>] \z/n
          "Telnetmode" => true,         # default: true
          "Timeout"    => 1,           # default: 10
          # if ignore timeout then set "Timeout" to false.
          "Waittime"   => 0            # default: 0
      # proxy is Net::ScannerUtils or IO object
      )

      response = host.cmd('')

    rescue Net::ReadTimeout, Errno::ECONNREFUSED, Net::OpenTimeout
      service = '-'
    end


    if response == nil
      puts "\n\nresponse is nil\n\n"
    elsif response.downcase.include? 'ssh'
      service = 'SSH'
    elsif response.downcase.include? 'http'
      service = 'http'
    elsif response.downcase.include? 'ftp'
      service = 'FTP'
    elsif response.downcase.include? 'SMTP'
      service = 'Mail server'
    end

    puts "\n\n---response--- " + response + " ------\n\n"

    service

  end


  def ping(host)
    check = Net::Ping::External.new(host)
    if !check.ping?

      @ack_scanner.set_dst_host(host)
      @ack_scanner.set_dst_port(80)

      status = @ack_scanner.scann

      if status != "filtered"
        true
      else
        false
      end

    else
      true
    end
  end

end