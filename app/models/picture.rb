class Picture < KmmObject
  attr_accessor :url, :title, :thumb, :original

  def attributes
    @attributes ||= {
      'url'     => nil,
      'title'   => nil,
      'thumb'   => nil,
      'original'=> nil
    }
  end
end
