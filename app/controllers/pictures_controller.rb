class PicturesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    if params[:meme_name].nil?
      res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/photos?page=#{page_num}"
    else
      res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/#{params[:meme_name]}/photos?page=#{page_num}&video_page=#{page_num}"
    end
    @pictures = Kym::Parser::Pictures.list(res.content)
    respond_with @pictures
  end
end
