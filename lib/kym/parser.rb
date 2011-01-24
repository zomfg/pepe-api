module Kym::Parser

  module Memes
    def Memes.single(page_html)
      JSON.parse page_html
    end

    def Memes.list(page_html)
      hpdoc = Hpricot page_html
      memes = []
      hpdoc.search('table.entry_list td').each do |meme_element|
        m = Meme.new
        m.title = meme_element.at('h2 a').inner_text
        m.thumb = meme_element.at('img').attributes['src']
        memes << m
      end
      memes
    end
  end

  module Comments
    def Comments.list(page_html)
      hpdoc = Hpricot page_html.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
      comments = []
      hpdoc.search('div.comments_list div.comment').each do |comment|
        c = Comment.new
        c.user_url  = comment.at('a').attributes['href']
        c.user_name = comment.at('a img').attributes['title']
        c.user_icon = comment.at('a img').attributes['src']
        c.message   = comment.at('div.message').inner_html
        comments << c
      end
      comments
    end
  end

  module Pictures
    def Pictures.list(page_html)
      hpdoc = Hpricot page_html
      pictures = []
      hpdoc.search('table.photo_list a.photo').each do |picture_element|
        thumb = picture_element.at('img').attributes
        p = Picture.new
        p.url     = picture_element.attributes['href']
        p.title   = thumb['title']
        p.thumb   = thumb['src']
        p.original= thumb['src'].gsub('list', 'original')
        pictures << p
      end
      pictures
    end
  end

  module Videos
    def Videos.list(page_html)
      hpdoc = Hpricot page_html
      videos = []
      hpdoc.search('table.video_list a.video').each do |video_element|
        thumb = video_element.at('img').attributes
        ytid = thumb['src'].split('/')[-2]
        ytid = nil if ytid.match(/[a-zA-Z0-9_-]{11}/).nil?
        v = Video.new
        v.url       = video_element.attributes['href']
        v.youtube_id= ytid
        v.title     = thumb['title']
        v.thumb     = thumb['src']
        videos << v
      end
      videos
    end
  end

  module Episodes
    def Episodes.list(page_html)
      hpdoc = Hpricot page_html.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
      episodes = []
      hpdoc.search('div#episodes_list div.episode').each do |episode|
        ytid = episode.at('div.video object param').attributes['value'].split('?')[0].split('/')[-1]
        ytid = nil if ytid.match(/[a-zA-Z0-9_-]{11}/).nil?
        info_elem = episode.at('div.body')
        e = Episode.new
        e.youtube_id  = ytid
        e.meme_url    = info_elem.at('h1 a').attributes['href']
        e.meme_name   = info_elem.at('h1 a').inner_html
        e.description = info_elem.at('p').inner_html
        episodes << e
      end
      episodes
    end
  end

  module Updates
    def Updates.list(page_html)
      hpdoc = Hpricot page_html.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
      updates = []
      hpdoc.search('div#feed_items div.nf_item div.rel').each do |update|
        u = Update.new
        u.status      = update.at('div.badge img').attributes['title']
        u.url         = update.at('div.info h1 a').attributes['href']
        u.meme_name   = update.at('div.info h1 a').inner_html
        u.description = update.at('div.summary').inner_html
        u.thumb       = update.at('a.photo img').attributes['src']
        updates << u
      end
      updates
    end
  end
end
