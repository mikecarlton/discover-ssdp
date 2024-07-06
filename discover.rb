#!/usr/bin/env ruby

require 'base64'

require_relative 'lib/ssdp'

# sample result
=begin
{ :address=>"192.168.1.220",
  :port=>59424,
  :status=>"HTTP/1.1 200 OK",
  :params=>{
      "CACHE-CONTROL"=>"max-age=1800", 
      "DATE"=>"Sat, 06 Jul 2024 14:52:38 GMT", 
      "LOCATION"=>"http://192.168.1.220:9080", 
      "OPT"=>"\"http://schemas.upnp.org/upnp/1/0/\"; ns=01", 
      "01-NLS"=>"08720494-3ba7-11ef-9228-ec45e348ad86", 
      "SERVER"=>"Linux/5.4.77, UPnP/1.0, Portable SDK for UPnP devices", 
      "X-User-Agent"=>"NRDP MDX", 
      "X-Friendly-Name"=>"U2Ftc3VuZyBRNjBCQSA2MCBUVg==", 
      "X-Accepts-Registration"=>"3", 
      "X-MSL"=>"1", 
      "X-MDX-Caps"=>" ", 
      "X-MDX-Registered"=>"1", 
      "X-MDX-Remote-Login-Supported"=>"0", 
      "X-MDX-Remote-Login-Requested-By-Witcher"=>"0", 
      "X-MDX-Link"=>"UZ2BPDLXY5EBHLUMBFP6H5IW5I", 
      "ST"=>"upnp:rootdevice", 
      "USN"=>"uuid:SSTV-NL22-0000000000000001196410::upnp:rootdevice"},
  :body=>nil}

=end

seconds = 10
puts "searching for devices on the local network for #{seconds} seconds..."
STDOUT.flush
SSDP::Consumer.new.search(service: 'ssdp:all', synchronous: true, timeout: seconds).each do |result|
  name = Base64.decode64(result.dig(:params, "X-Friendly-Name") || "")
  location = result.dig(:params, "LOCATION")
  if location =~ /(\d{1,3}(\.\d{1,3}){3})/ then
    ip = $&
  end

  puts "#{result[:params]["LOCATION"]}  #{ip}  #{name}"
end