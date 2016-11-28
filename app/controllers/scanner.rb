require 'packetfu'

class Scanner

  def icmp_scan(ip)

    config = PacketFu::Utils.whoami?()
    status = '?'

    # create icmp packet
    icmp_packet = PacketFu::ICMPPacket.new(:config => config)
    icmp_packet.ip_daddr = ip
    icmp_packet.payload = "ICPM probe"

    icmp_packet.icmp_type = 8 # echo

    icmp_packet.recalc

    capture_thread = Thread.new do
      begin
        Timeout::timeout(1) {
          cap = PacketFu::Capture.new(:iface => config[:iface], :start => true)
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
            next unless pkt.is_icmp?
            if pkt.ip_saddr == ip and pkt.icmp_type == 0 # echo reply form destintation host
              status = 'up'
              break
            end
          end
        }
      rescue Timeout::Error
        status = 'down'
      end
    end

    10.times do
      icmp_packet.to_w
    end

    capture_thread.join
    status

  end

  def tcp_syn_scan(ip, port)

    config = PacketFu::Utils.whoami?()
    status = '?'

    tcp_syn_packet = PacketFu::TCPPacket.new(:config => config)
    tcp_syn_packet.ip_daddr = ip
    tcp_syn_packet.payload = "TCP ack probe"

    tcp_syn_packet.tcp_flags.syn = 1
    tcp_syn_packet.tcp_dst = port
    tcp_syn_packet.tcp_src = 2000

    tcp_syn_packet.recalc

    capture_thread = Thread.new do
      begin
        Timeout::timeout(4) {
          cap = PacketFu::Capture.new(:iface => config[:iface], :start => true, :promisc => true) #promisc?
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
            next unless pkt.is_tcp?
            if pkt.ip_saddr == ip and pkt.ip_saddr == ip and pkt.tcp_dport ==  tcp_syn_packet.tcp_src
              if pkt.tcp_flags.syn == 1 and pkt.tcp_flags.ack == 1
                status = 'up'
                break
              elsif pkt.tcp_flags.rst == 1
                status = 'down'
                break
              end
            end
          end
        }
      rescue Timeout::Error
        status = 'filtered'
      end
    end

    10.times do
      tcp_syn_packet.to_w
    end

    capture_thread.join

   status

  end

  def tcp_fin_scan(ip, port)

    config = PacketFu::Utils.whoami?()
    status = '?'

    tcp_fin_packet = PacketFu::TCPPacket.new(:config => config)
    tcp_fin_packet.ip_daddr = ip
    tcp_fin_packet.payload = "TCP fin probe"

    tcp_fin_packet.tcp_flags.fin = 1
    tcp_fin_packet.tcp_dst = port
    tcp_fin_packet.tcp_src = 2000

    tcp_fin_packet.recalc

    capture_thread = Thread.new do
      begin
        Timeout::timeout(1) {
          cap = PacketFu::Capture.new(:iface => config[:iface], :start => true) # :promisc => true
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
            next unless pkt.is_ip? or pkt.is_tcp?
            if pkt.ip_saddr == ip and pkt.ip_saddr == ip and pkt.tcp_dport == tcp_fin_packet.tcp_src and pkt.tcp_flags.rst == 1
              status = 'down'
              break
            end
          end
        }
      rescue Timeout::Error
        status = 'up'
      end
    end

    10.times do
      tcp_fin_packet.to_w
    end

    capture_thread.join

    status

    end
  end

