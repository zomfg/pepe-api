class EpisodesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/episodes?page=#{page_num}"
    begin
      @episodes = Kym::Parser::Episodes.list res.content
    rescue
      http_error :parsing_error
    else
      respond_with @episodes
    end unless bad_response? res
  end
end
