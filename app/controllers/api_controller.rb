class ApiController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate

  def initialize
    @kym_client = Kym::Client.new
  end

  private
  def authenticate
    for header in request.headers.select {|k,v| k.match("^HTTP.*")}
      p "#{header[0].gsub('HTTP_','').dasherize}: #{header[1]}"
    end
    if request.headers[KYM_CONFIG['api']['request_signature_header']].nil?
      http_error 401 and return
    end
    require 'hmac-sha1'
    signature_componenets = []
    KYM_CONFIG['api']['request_signature_components'].split(',').each {|k| signature_componenets << request.env[k]}
    signature_componenets = signature_componenets.join('|')
    expected_signature = HMAC::SHA1.hexdigest(KYM_CONFIG['api']['secret_key'], signature_componenets)
    http_error 403 if Base64.decode64(request.headers[KYM_CONFIG['api']['request_signature_header']]) != expected_signature
  end

  def http_error(status_code)
    headers[KYM_CONFIG['api']['response_message_header']] = "EPIC_FAIL"
    render :nothing => true, :status => status_code
  end
end
