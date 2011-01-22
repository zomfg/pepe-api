class ApiController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :authenticate

  def initialize
    @kym_client = Kym::Client.new
    @http_errors = {
      :success        => [200, 'SUCCESS'],
      :bad_request    => [400, 'BAD_REQUEST'],
      :bad_signature  => [401, 'BAD_SIGNATURE'],
      :cant_login     => [403, 'CANT_LOG_INTO_KYM'],
      :not_found      => [404, 'NOT_FOUND'],
      :no_signature   => [417, 'NO_SIGNATURE'],
      :internal_error => [500, 'INTERNAL_FAIL'],
      :parsing_error  => [500, 'PARSING_FAIL'],
      :not_implemented=> [501, 'NOT_IMPLEMENTED'],
      :kym_error      => [503, 'KYM_FAIL'],
      :kym_timeount   => [504, 'KYM_TIMEOUT']
    }
  end

  private
  def authenticate
    for header in request.headers.select {|k,v| k.match("^HTTP.*")}
      p "#{header[0].gsub('HTTP_','').dasherize}: #{header[1]}"
    end
    if request.headers[KYM_CONFIG['api']['request_signature_header']].nil?
      http_error :no_signature and return
    end
    require 'hmac-sha1'
    signature_componenets = []
    KYM_CONFIG['api']['request_signature_components'].split(',').each {|k| signature_componenets << request.env[k]}
    signature_componenets = signature_componenets.join('|')
    expected_signature = HMAC::SHA1.new(KYM_CONFIG['api']['secret_key'])
    expected_signature.update(signature_componenets)
    http_error :bad_signature if request.headers[KYM_CONFIG['api']['request_signature_header']] != Base64.encode64(expected_signature.digest).strip && \
      request.headers[KYM_CONFIG['api']['request_signature_header']] != Base64.encode64(expected_signature.hexdigest).strip
  end

  def http_error(error_code)
    raise error_code.inspect if @http_errors[error_code].nil?
    headers[KYM_CONFIG['api']['response_message_header']] = @http_errors[error_code][1]
    render :nothing => true, :status => @http_errors[error_code][0]
  end

  def bad_response?(res)
    http_error :internal_error and return true if res.nil?
    http_error :kym_error and return true if res.status_code == 500
    return false
  end
end
