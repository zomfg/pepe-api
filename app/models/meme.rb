class Meme < KmmObject
  attr_accessor :title, :thumb

  def attributes
    @attributes ||= {
      'title' => nil,
      'thumb' => nil
    }
  end
end
