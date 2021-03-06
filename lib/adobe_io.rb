require 'adobe_io/version'
require 'adobe_io/authenticator'
require 'dry-configurable'

module AdobeIO
  extend ::Dry::Configurable

  setting :logger, Logger.new(STDOUT), reader: true
  setting :client_secret, nil, reader: true
  setting :api_key, nil, reader: true
  setting :ims_host, nil, reader: true
  setting :private_key, nil, reader: true
  setting :iss, nil, reader: true
  setting :sub, nil, reader: true
  setting :scope, nil, reader: true

  class AccessToken
    attr_reader :client_secret, :api_key, :ims_host, :private_key, :scope

    def generate
      @access_token ||= fetch_access_token
    end

    def fetch_access_token
      opts = {
        client_secret: AdobeIO.client_secret,
        api_key: AdobeIO.api_key,
        ims_host: AdobeIO.ims_host,
        private_key: AdobeIO.private_key,
        expiry_time: Time.now.to_i + (60 * 60 * 24),
        scope: AdobeIO.scope
      }
      response = Authenticator.new(opts).exchange_jwt
      response['access_token']
    rescue Exception => e
      AdobeIO.logger.error "There was an error with your request: #{e.message}"
      raise e
    end
  end

  def self.generate
    AccessToken.new.generate
  end
end
