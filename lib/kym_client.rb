class KymClient
  def initialize
    @http_client = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
  end

  def get_page(page_url)
    @http_client.get page_url
  end
end
