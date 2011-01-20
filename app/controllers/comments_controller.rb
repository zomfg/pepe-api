class CommentsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}/comments?page=#{page_num}&comment_page=#{page_num}"
    hpdoc = Hpricot res.content.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
    @comments = []
    hpdoc.search('div.comments_list div.comment').each do |comment|
      @comments << {
        :user_url => comment.at('a').attributes['href'],
        :user_name => comment.at('a img').attributes['title'],
        :user_icon => comment.at('a img').attributes['src'],
        :message => comment.at('div.message').inner_html
        }
    end
    respond_with @comments
  end
end
