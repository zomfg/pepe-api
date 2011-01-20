class VideosController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    if params[:meme_name].nil?
      res = clt.get "#{KYM_CONFIG['kym_base_uri']}/videos?page=#{page_num}"
    else
      res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}/videos?page=#{page_num}&video_page=#{page_num}"
    end
    hpdoc = Hpricot res.content
    @videos = []
    hpdoc.search('table.video_list a.video').each do |video_element|
      thumb = video_element.at('img').attributes
      ytid = thumb['src'].split('/')[-2]
      ytid = nil if ytid.match(/[a-zA-Z0-9_-]{11}/).nil?
      @videos << {
        :url => video_element.attributes['href'],
        :youtube_id => ytid,
        :title => thumb['title'],
        :thumb => thumb['src'],
        }
    end
    respond_with @videos
  end

  def show

  end
end
