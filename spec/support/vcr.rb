require 'vcr'

module VCRHelper

  OAUTH_HEADER_REGEX = /oauth_(nonce|signature|timestamp)=.*?( |$)/ # Variable params

module_function

  def add_placeholder(key)
    placeholders[key] = nil
  end

  def placeholders
    @placeholders ||= {}
  end

  def oauth_header_matcher
    lambda do |r1, r2|
      normalize_oauth_header(r1.headers) == normalize_oauth_header(r2.headers)
    end
  end

  def normalize_oauth_header(headers)
    headers['Authorization'].map { |h| h.gsub(OAUTH_HEADER_REGEX, '') }
  end

  def header_matcher(header)
    lambda do |request1, request2|
      request1.headers[header] == request2.headers[header]
    end
  end

  def use_cassette(*args, &block)
    init and VCR.use_cassette(*args, &block)
  end

  def init
    @config ||= VCR.configure do |config|
      config.cassette_library_dir = "spec/support/vcr_cassettes"
      config.hook_into :webmock
      config.ignore_localhost = true
      #config.debug_logger = STDOUT
      placeholders.keys.each do |key|
        config.define_cassette_placeholder(key) { placeholders[key] }
      end

      config.register_request_matcher(:oauth_header, &oauth_header_matcher)
    end
  end

end
