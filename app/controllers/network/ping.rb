#!/usr/bin/env ruby

require 'net/ping'

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
