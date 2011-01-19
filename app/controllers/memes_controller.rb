class MemesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/all?page=#{page_num}"
    hpdoc = Hpricot res.content
    @memes = []
    hpdoc.search('table.entry_list td').each do |meme_element|
      title_link = meme_element.at('h2 a')
      thumb = meme_element.at('img').attributes
      @memes << {
        :title => title_link.inner_text,
        :slug => title_link.attributes['href'].split('/').last,
        :thumb => thumb['src'].split('?').first
        }
    end
    respond_with @memes
  end

  def show
    clt = HTTPClient.new(:agent_name => "Firefox")
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}.json"
    @meme = JSON.parse res.content
    respond_with @meme
  end
end
