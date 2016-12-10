#!/usr/bin/env ruby

require 'net/ping'

def ping(host)
  check = Net::Ping::External.new(host)
  check.ping?
end

