class CommentsController < ApiController
  def index
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = @kym_client.get_page "#{KYM_CONFIG['kym']['base_uri']}/memes/#{params[:meme_name]}/comments?page=#{page_num}&comment_page=#{page_num}"
    @comments = Kym::Parser::Comments.list res.content
    respond_with @comments
  end
end
