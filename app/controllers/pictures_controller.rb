class PicturesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    clt = HTTPClient.new(:agent_name => "Firefox")
    res = clt.get "#{KYM_CONFIG['kym_base_uri']}/memes/#{params[:meme_name]}"
    hpdoc = Hpricot res.content
    @pictures = []
    hpdoc.search('table.photo_list a.photo').each do |picture_element|
      thumb = picture_element.at('img').attributes
      thumb['src'] = thumb['src'].split('?').first
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
