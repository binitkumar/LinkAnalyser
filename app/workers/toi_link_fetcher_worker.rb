require 'open-uri'

class ToiLinkFetcherWorker
  include Sidekiq::Worker

  def perform(news_date = nil)
    date_pair = ["04/01/2019", 43469]
    last_parsed_date = LinkCollection.order("news_date asc").first

    start_date = nil
    page_url = nil
    publication_date = date_pair[0]

    if last_parsed_date
      last_parsed_date = last_parsed_date.news_date
      end_date = Date.parse(date_pair[0])
      start_date = last_parsed_date.prev_day
      toi_seq = date_pair[1] - (end_date - start_date).to_i
      page_url = "https://timesofindia.indiatimes.com/#{start_date.strftime("%Y/%m/%d")}/archivelist/year-#{start_date.year},month-#{start_date.month},starttime-#{toi_seq}.cms"
    else
      start_date = Date.parse(date_pair[0])
      page_url = "https://timesofindia.indiatimes.com/2019/1/4/archivelist/year-2019,month-1,starttime-43469.cms"
    end

    puts page_url

    link_collection = LinkCollection.create(
      link: page_url,
      news_date: start_date 
    )

    doc = Nokogiri::HTML(open(page_url))

    links = doc.css('a')
    hrefs = links.map {|link| link.attribute('href').to_s}.uniq.sort.delete_if {|href| href.empty?}
    hrefs = hrefs.select{|url| 
      #( /\/city/.match(url) || /\/india/.match(url) ) && 
      url.include?(".cms") &&
      url.include?("articleshow")
    }

    hrefs.each do |link|
      page_link = nil
      if link.include?("timesofindia.indiatimes.com")
        page_link= link
      else
        page_link= "https://timesofindia.indiatimes.com#{link}"
      end
      Message.create(
        link: page_link,
        publication_date: start_date,
        link_collection_id: link_collection.id
      )
    end
  end

  def fetch_default_page_url
  end
end
