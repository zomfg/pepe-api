class VideosController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => "Firefox")
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}"
    hpdoc = Hpricot res.content
    @videos = []
    hpdoc.search('table.video_list a.video').each do |video_element|
      thumb = video_element.at('img').attributes
      thumb['src'] = thumb['src'].split('?').first
      ytid = thumb['src'].split('/')[-2]
      ytid = nil if ytid.match(/[a-zA-Z0-9]{11}/).nil?
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