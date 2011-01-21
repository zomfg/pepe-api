class UpdatesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/index?page=#{page_num}"
    @updates = Kym::Parser::Updates.list res.content
    respond_with @updates
  end
end
