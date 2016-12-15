require 'packetfu'

class FastScann

  private


  def checkIfFiltered (ip, port)

    src = 1998
    timeout_value = 5
    tries = 10
    sleep_time = 0

    scanner = ACK_scanner.new(src, timeout_value, tries, sleep_time)
    scanner.set_dst_host(ip)
    scanner.set_dst_port(port)
    status = scanner.scann

    return status == 'unfiltered'

  end

  def checkIfUpForTCP (ip, port)

    src = 1998
    timeout_value = 5
    tries = 10
    sleep_time = 0

    scanner = FIN_scanner.new(src, timeout_value, tries, sleep_time)
    scanner.set_dst_host(ip)
    scanner.set_dst_port(port)
    status_fin = scanner.scann

    scanner2 = SYN_scanner.new( src, timeout_value, tries, sleep_time)
    scanner2.set_dst_host(ip)
    scanner2.set_dst_port(port)
    status_syn = scanner2.scann

    return status_fin == 'up' || status_syn =='up'

  end

  def checkIfUpForUDP (ip, port)

    dst = 53
    src = 1998
    timeout_value = 22
    tries = 4
    sleep_time = 5

    scanner = UDP_scanner.new( src, timeout_value, tries, sleep_time)
    scanner.set_dst_host(ip)
    scanner.set_dst_port(port)

    host_addr, dst,

    status = scanner.scann

    return status == 'up'

  end

  def scannTCP(ip, port)

    if ping(ip)
      if checkIfFiltered(ip,port)
        if checkIfUpForTCP(ip,port)
          return true
        end
      end
    else
      return false
    end

  end

  def scannUDP(ip, port)

    if checkIfUpForUDP(ip,port)
      return true
    end

  end

  # todo repetition of ping method
  def ping(host)
    check = Net::Ping::External.new(host)
    if !check.ping?

      @ack_scanner.set_dst_host(host)
      @ack_scanner.set_dst_port(80)

      status = @ack_scanner.scann

      if status != "filtered"
        return true
      else
        return false
      end

    else
      return true
    end

  end

  def scann(ip)

    if ping(ip)
      @tcp_ports.each do |port|
        if scannTCP(ip, port)
          @hosts.push(Host.new(:scan_id => '1', :IP => ip, :port => port, :status => 'up', :scann_type => 'tcp', :scann_time => 1, :service => " "))
          # @open_tcp_ports.push(port)
        end
      end

      @udp_ports.each do |port|
        if scannUDP(ip, port)
          # @open_udp_ports.push(port)
          @hosts.push(Host.new(:scan_id => '1', :IP => ip, :port => port, :status => 'up', :scann_type => 'udp', :scann_time => 1, :service => " "))
        end
      end
    end
  end

  public

  @tcp_ports
  @udp_ports
  @open_tcp_ports = []
  @open_udp_ports = []
  @hosts = []


  def performFastScann()

    @config = PacketFu::Utils.whoami?()

    @tcp_ports = [21,22,23,24,25,53,80,443,1723,3389,4567,8080]
    @udp_ports = [53,111,123,137,161]


    ip = @config[:ip_saddr].split(".")
    network = ip[0] + '.' + ip[1] + '.' + ip[2] + '.'

    (1..255).each do |host|
      scann(network + host.to_s)
    end


    @hosts

  end

end
