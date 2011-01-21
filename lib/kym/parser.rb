module Kym::Parser

  module Memes
    def Memes.single(page_html)
      JSON.parse page_html unless page_html.match(/<html/)
    end

    def Memes.list(page_html)
      hpdoc = Hpricot page_html
      memes = []
      hpdoc.search('table.entry_list td').each do |meme_element|
        title_link = meme_element.at('h2 a')
        thumb = meme_element.at('img').attributes
        memes << {
          :title => title_link.inner_text,
          :slug => title_link.attributes['href'].split('/').last,
          :thumb => thumb['src']
          }
      end
      memes
    end
  end

  module Comments
    def Comments.list(page_html)
      hpdoc = Hpricot page_html.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
      comments = []
      hpdoc.search('div.comments_list div.comment').each do |comment|
        comments << {
          :user_url => comment.at('a').attributes['href'],
          :user_name => comment.at('a img').attributes['title'],
          :user_icon => comment.at('a img').attributes['src'],
          :message => comment.at('div.message').inner_html
          }
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
        pictures << {
          :url => picture_element.attributes['href'],
          :title => thumb['title'],
          :thumb => thumb['src'],
          :original => thumb['src'].gsub('list', 'original')
          }
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
        videos << {
          :url => video_element.attributes['href'],
          :youtube_id => ytid,
          :title => thumb['title'],
          :thumb => thumb['src'],
          }
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
        episodes << {
          :youtube_id => ytid,
          :meme_url => info_elem.at('h1 a').attributes['href'],
          :meme_name => info_elem.at('h1 a').inner_html,
          :short_description => info_elem.at('p').inner_html
        }
      end
      episodes
    end
  end

  module Updates
    def Updates.list(page_html)
      hpdoc = Hpricot page_html.gsub(/(<\/?)(article|section)(>?)/, '\\1div\\3')
      updates = []
      hpdoc.search('div#feed_items div.nf_item div.rel').each do |update|
        updates << {
          :status => update.at('div.badge img').attributes['title'],
          :meme_url => update.at('div.info h1 a').attributes['href'],
          :meme_name => update.at('div.info h1 a').inner_html,
          :short_description => update.at('div.summary').inner_html,
          :thumb => update.at('a.photo img').attributes['src']
        }
      end
      updates
    end
  end
end
