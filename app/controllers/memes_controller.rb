class MemesController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/all?page=#{page_num}"
    begin
      @memes = Kym::Parser::Memes.list res.content
    rescue
      http_error :parsing_error
    else
      respond_with @memes
    end unless bad_response? res
  end

  def show
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/#{params[:id]}.json"
    begin
      @meme = Kym::Parser::Memes.single res.content
    rescue
      http_error :parsing_error
    else
      respond_with @meme
    end unless bad_response? res
  end
end
