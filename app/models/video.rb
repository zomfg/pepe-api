class Video < KmmObject
  attr_accessor :url, :title, :thumb, :youtube_id

  def attributes
    @attributes ||= {
      'url'       => nil,
      'title'     => nil,
      'thumb'     => nil,
      'youtube_id'=> nil
    }
  end
end
