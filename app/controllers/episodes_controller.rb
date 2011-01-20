class EpisodesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/episodes?page=#{page_num}"
    hpdoc = Hpricot res.content.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
    @episodes = []
    hpdoc.search('div#episodes_list div.episode').each do |episode|
      ytid = episode.at('div.video object param').attributes['value'].split('?')[0].split('/')[-1]
      ytid = nil if ytid.match(/[a-zA-Z0-9_-]{11}/).nil?
      info_elem = episode.at('div.body')
      @episodes << {
        :youtube_id => ytid,
        :meme_url => info_elem.at('h1 a').attributes['href'],
        :meme_name => info_elem.at('h1 a').inner_html,
        :short_description => info_elem.at('p').inner_html
      }
    end
    respond_with @episodes
  end
end
