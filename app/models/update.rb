class Update < KmmObject
  attr_accessor :url, :description, :thumb, :status, :meme_name

  def attributes
    @attributes ||= {
      'url'         => nil,
      'description' => nil,
      'thumb'       => nil,
      'meme_name'   => nil
      }
    end
end
