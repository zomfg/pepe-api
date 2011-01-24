class PicturesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    if params[:meme_name].nil?
      res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/photos?page=#{page_num}"
    else
      res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/#{params[:meme_id]}/photos?page=#{page_num}&video_page=#{page_num}"
    end
    begin
      @pictures = Kym::Parser::Pictures.list(res.content)
    rescue
      http_error :parsing_error
    else
      respond_with @pictures
    end unless bad_response? res
  end
end
