class EpisodesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym_base_uri']}/memes/episodes?page=#{page_num}"
    @episodes = KymParser::Episodes.list res.content
    respond_with @episodes
  end
end
