include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::XMLSitemap

def grouped_articles
    sorted_articles.group_by do |article|
        Time.parse(article[:created_at]).year
    end.sort.reverse
end
