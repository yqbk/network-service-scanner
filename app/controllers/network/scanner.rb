require 'packetfu'

class Scanner

  private
  @ip
  @dst
  @src
  @timeout_value
  @tries
  @config

  def initialize(src, timeout_value, tries, sleep_time)

    @src = src
    @timeout_value = timeout_value
    @tries = tries
    @sleep_time = sleep_time
    @config = PacketFu::Utils.whoami?()
    @status = ""

  end

  def prepare

    packet = PacketFu::TCPPacket.new(:config => @config)
    packet.ip_daddr = @ip
    packet.tcp_dst = @dst
    packet.tcp_src = @src

    additional_config(packet)

    packet.recalc

    packet
  end

  def additional_config(packet)
    # packet.payload = "TCP sny probe"   it oculd be error?
    packet.tcp_flags.syn = 1
    packet
  end

  def check_packet_type(pkt)
    pkt.is_tcp?
  end

  def check_if_icmp(pkt)
    pkt.is_icmp?
  end

  def check_packet_flags(pkt)
    pkt.ip_saddr == @ip and pkt.tcp_dst == @prepared_packet.tcp_src and pkt.tcp_src == @dst and pkt.tcp_flags.syn == 1
  end

  def check_tcp_rst(pkt)
    pkt.ip_saddr == @ip and pkt.tcp_dst == @prepared_packet.tcp_src and pkt.tcp_src == @dst and pkt.tcp_flags.rst == 1
  end

  def check_icmp(pkt)
    pkt.ip_saddr == @ip and pkt.icmp_type == 3 and (pkt.icmp_code == 0 or 1 or 2 or 3 or 9 or 10 or 13)
  end


  def on_icmp_check_success
    puts "SYN: #{@ip} is fitered (icmp received) on port #{@dst}"
    set_status("filtered")
  end

  def on_timeout
    puts "SYN: #{@ip} is filtered on port #{@dst}"
    set_status("filtered")
  end

  def is_successful
    puts "SYN: #{@ip} is up on port #{@dst}"
    set_status("up")
  end

  def is_not_successful
    puts "SYN: #{@ip} is down on port #{@dst}"
    set_status("down")
  end

  def is_filtered
    puts "SYN: #{@ip} is filtered on port #{@dst}"
    set_status("filtered")
  end

  def set_status(val)
    @status = val
  end

  public

  def set_dst_port(port)
    @dst = port
    @prepared_packet = prepare
  end

  def set_dst_host(ip)
    @ip = ip
    @prepared_packet = prepare
  end

  def scann

    capture_thread = Thread.new do
      begin
        Timeout::timeout(@timeout_value) {
          cap = PacketFu::Capture.new(:iface => @config[:iface], :start => true)
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
            if check_packet_type(pkt)
              if check_packet_flags(pkt)
                is_successful
                break
              elsif check_tcp_rst(pkt)
                is_not_successful
                break
              end
            elsif check_if_icmp(pkt) and check_icmp(pkt)
              on_icmp_check_success
              break
            else
              next
            end
          end
        }
      rescue Timeout::Error
        on_timeout
      end
    end
    @tries.times do
      @prepared_packet.to_w
    end
    capture_thread.join
    return @status
  end

end

class FIN_scanner < Scanner

  def additional_config(packet)
    # packet.payload = "TCP sny probe"
    packet.tcp_flags.fin = 1
    packet
  end

  def check_packet_flags(pkt)
    pkt.ip_saddr == @ip and pkt.tcp_dst == @prepared_packet.tcp_src and pkt.tcp_src == @dst and pkt.tcp_flags.rst == 1
  end

  # when responded with rst port is down
  def is_successful
    puts "FIN: #{@ip} is down on port #{@dst}"
    set_status("down")
  end

  def on_timeout
    puts "FIN: #{@ip} is up on port #{@dst}"
    set_status("up")
  end

end

class SYN_scanner < Scanner

end

class ACK_scanner < Scanner

  def additional_config(packet)
    # packet.payload = "TCP sny probe"
    packet.tcp_flags.ack = 1
    packet
  end

  def check_packet_flags(pkt)
    pkt.ip_saddr == @ip and pkt.tcp_dst == @prepared_packet.tcp_src and pkt.tcp_src == @dst and pkt.tcp_flags.rst == 1
  end

  # when responded with rst port is down
  def is_successful
    puts "ACK: #{@ip} is unfiltered on port #{@dst}"
    set_status("unfiltered")
  end

  def on_timeout
    puts "ACK: #{@ip} is filtered on port #{@dst}"
    set_status("filtered")
  end

  def on_icmp_check_success
    puts "ACK: #{@ip} is filtered on port #{@dst}"
    set_status("filtered")
  end

end

class UDP_scanner < Scanner

  def prepare

    packet = PacketFu::UDPPacket.new(:config => @config)
    packet.ip_daddr = @ip
    packet.udp_dst = @dst
    packet.udp_src = @src

    packet.recalc

    packet
  end

  def check_packet_type(pkt)
    pkt.is_udp? and pkt.ip_saddr == @ip
  end

  def check_if_icmp(pkt)
    pkt.is_icmp?
  end

  def on_timeout
    puts "UDP: #{@ip} is open|filtered on port #{@dst}"
    set_status("open or filtered")
  end

  def is_successful
    puts "UDP: #{@ip} is up on port #{@dst}"
    set_status("up")
  end

  def is_not_successful
    puts "UDP: #{@ip} is down on port #{@dst}"
    set_status("down")
  end

  public

  def scann

    capture_thread = Thread.new do
      begin
        Timeout::timeout(@timeout_value) {
          cap = PacketFu::Capture.new(:iface => @config[:iface], :start => true)
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
#             puts("czujka -> " + @dst.to_s)
            if check_packet_type(pkt)
              is_successful
              break
            elsif check_if_icmp(pkt)
#               puts (" dostałem icmp: " + pkt.icmp_type.to_s + " - " + pkt.icmp_code.to_s)
              if pkt.icmp_type == 3 and pkt.icmp_code == 3
                is_not_successful
              elsif pkt.icmp_type == 3 and (pkt.icmp_code == 0 or 1 or 2 or 9 or 10 or 13)
                is_filtered
              end
              break
            else
              next
            end
          end
        }
      rescue Timeout::Error
        on_timeout
      end
    end
    @tries.times do
      @prepared_packet.to_w
      sleep @sleep_time
    end
    capture_thread.join
    return @status
  end

end