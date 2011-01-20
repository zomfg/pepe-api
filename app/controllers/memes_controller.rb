class MemesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym_base_uri']}/memes/all?page=#{page_num}"
    @memes = KymParser::Memes.list res.content
    respond_with @memes
  end

  def show
    res = @kym_client.get_page "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}.json"
    @meme = KymParser::Memes.single res.content
    respond_with @meme
  end
end
