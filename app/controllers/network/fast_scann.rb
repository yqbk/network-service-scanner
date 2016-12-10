class FastScann

  private
  @tcp_ports = [21,22,23,24,25,53,80,443,1723,3389,4567,8080]
  @udp_ports = [53,111,123,137,161]


  def checkIfFiltered (ip, port)

    src = 1998
    timeout_value = 5
    tries = 10
    sleep_time = 0

    scanner = ACK_scanner.new(ip, port, src, timeout_value, tries, sleep_time)
    status = scanner.scann

    return status == 'unfiltered'

  end

  def checkIfUpForTCP (ip, port)

    src = 1998
    timeout_value = 5
    tries = 10
    sleep_time = 0

    scanner = FIN_scanner.new(ip, port, src, timeout_value, tries, sleep_time)
    status_fin = scanner.scann

    scanner = SYN_scanner.new(ip, port, src, timeout_value, tries, sleep_time)
    status_syn = scanner.scann

    return status_fin == 'up' || status_syn =='up'

  end

  def checkIfUpForUDP (ip, port)

    dst = 53
    src = 1998
    timeout_value = 22
    tries = 4
    sleep_time = 5

    scanner = UDP_scanner.new(host_addr, dst, src, timeout_value, tries, sleep_time)
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

  public

  @open_tcp_ports = []
  @open_udp_ports = []


  def performFastScann(ip)

    if ping(ip)
      @tcp_ports.each do |port|
        if scannTCP(ip, port)
          @open_tcp_ports.push(port)
        end
      end

      @udp_ports.each do |port|
        if scannUDP(ip, port)
          @open_udp_ports.push(port)
        end
      end
    end

  end

end
