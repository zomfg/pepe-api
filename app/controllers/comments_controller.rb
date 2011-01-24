class CommentsController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/#{params[:meme_id]}/comments?page=#{page_num}&comment_page=#{page_num}"
    begin
      @comments = Kym::Parser::Comments.list res.content
    rescue
      http_error :parsing_error
    else
      respond_with @comments
    end unless bad_response? res
  end
end
