class PicturesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => KYM_CONFIG['api_agent_name'])
    page_num = (params[:page].nil? ? 1 : params[:page])
    if params[:meme_name].nil?
      res = clt.get "#{KYM_CONFIG['kym_base_uri']}/photos?page=#{page_num}"
    else
      res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}/photos?page=#{page_num}&video_page=#{page_num}"
    end
    hpdoc = Hpricot res.content
    @pictures = []
    hpdoc.search('table.photo_list a.photo').each do |picture_element|
      thumb = picture_element.at('img').attributes
      @pictures << {
        :url => picture_element.attributes['href'],
        :title => thumb['title'],
        :thumb => thumb['src'],
        :original => thumb['src'].gsub('list', 'original')
        }
    end
    respond_with @pictures
  end
end
