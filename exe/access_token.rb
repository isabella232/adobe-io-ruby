#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require "adobe_io"

# Exit cleanly from an early interrupt
Signal.trap("INT") { exit 1 }


AdobeIo.configure do |config|
  config.client_secret = ENV['IO_CLIENT_SECRET']
  config.api_key = ENV['IO_API_KEY']
  config.ims_host = ENV['IO_IMS_HOST']
  config.private_key = ENV['IO_PRIVATE_KEY']
  config.iss = ENV['IO_ISS']
  config.sub = ENV['IO_SUB']
  config.logger.level = Logger::DEBUG if ARGV.include? '-v'
end

puts AdobeIo::AccessToken.new.generate
