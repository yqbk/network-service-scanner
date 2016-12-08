require 'packetfu'

class Scanner

  def icmp_scan(ip)

    config = PacketFu::Utils.whoami?()
    status = false

    # create icmp packet
    icmp_packet = PacketFu::ICMPPacket.new(:config => config)
    icmp_packet.ip_daddr = ip
    icmp_packet.payload = "ICPM probe"

    icmp_packet.icmp_type = 8 # echo

    icmp_packet.recalc

    capture_thread = Thread.new do
      begin
        Timeout::timeout(10) {
          cap = PacketFu::Capture.new(:iface => config[:iface], :start => true)
          cap.stream.each do |p|
            pkt = PacketFu::Packet.parse p
            next unless pkt.is_icmp?
            if pkt.ip_saddr == ip and pkt.icmp_type == 0 # echo reply form destintation host
              status = true
            end
          end
        }
      rescue Timeout::Error
      end
    end

    10.times do
      icmp_packet.to_w
    end

    capture_thread.join

    if status
      return 'up'
    else
      return 'down'
    end

  end


end

