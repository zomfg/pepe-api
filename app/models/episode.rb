class Episode < KmmObject
  attr_accessor :meme_url, :meme_name, :youtube_id, :description

  def attributes
    @attributes ||= {
      'meme_url'    => nil,
      'meme_name'   => nil,
      'youtube_id'  => nil,
      'description' => nil
    }
  end
end
