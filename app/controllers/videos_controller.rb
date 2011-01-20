class VideosController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    if params[:meme_name].nil?
      res = @kym_client.get_page "#{KYM_CONFIG['kym_base_uri']}/videos?page=#{page_num}"
    else
      res = @kym_client.get_page "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}/videos?page=#{page_num}&video_page=#{page_num}"
    end
    @videos = KymParser::Videos.list res.content
    respond_with @videos
  end
end
