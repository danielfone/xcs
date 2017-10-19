require 'support/vcr'

VCRHelper.add_placeholder('<XERO_CONSUMER_KEY>')
VCRHelper.add_placeholder('<XERO_CONSUMER_SECRET>')

module XeroHelper

  def with_xero_cassette(&block)
    VCRHelper.placeholders['<XERO_CONSUMER_KEY>'] = xero_config[:consumer_key]
    VCRHelper.placeholders['<XERO_CONSUMER_SECRET>'] = xero_config[:consumer_secret]

    VCRHelper.use_cassette(
      'xero/api',
      match_requests_on: [
        :method,
        :uri,
        :body,
        :oauth_header,
        VCRHelper.header_matcher('If-Modified-Since'),
      ],
      allow_playback_repeats: true,
      &block
    )
  end

  private

  def xero_config
    Rails.application.secrets[:xero]
  end

end
