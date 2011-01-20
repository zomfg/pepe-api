class UpdatesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/index?page=#{page_num}"
    hpdoc = Hpricot res.content.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
    @updates = []
    hpdoc.search('div#feed_items div.nf_item div.rel').each do |update|
      @updates << {
        :status => update.at('div.badge img').attributes['title'],
        :meme_url => update.at('div.info h1 a').attributes['href'],
        :meme_name => update.at('div.info h1 a').inner_html,
        :short_description => update.at('div.summary').inner_html,
        :thumb => update.at('a.photo img').attributes['src']
      }
    end
    respond_with @updates
  end
end
