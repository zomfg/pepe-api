class Comment < KmmObject
  attr_accessor :user_url, :user_name, :user_icon, :message

  def attributes
    @attributes ||= {
      'user_url'  => nil,
      'user_name' => nil,
      'user_icon' => nil,
      'message'   => nil
      }
    end
end
