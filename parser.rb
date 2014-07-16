require 'nokogiri'
require 'open-uri'
require 'pry'

def doc(html)
  Nokogiri::HTML(open('html'))
end

def all_links(doc)
  doc.css('.frontLink')
end

def entity_names(doc)
  all_links(doc).inject([]) { |names, link| names << link.text.strip }
end

def entity_links(doc)
  all_links(doc).inject([]) { |links, link| links << link['href'] }
end

def entities(doc)
  entities = entity_names(doc).zip(entity_links(doc))
end

def paragraphs(page)
  page.xpath('//b[contains(text(), "In support of Rio+20 outcome paragraph")]')
end

def all_paragraph_nums(page)
  paragraphs(page).inject([]) do |paragraph_nums, paragraph|
    formatted_paragraph = paragraph.text.strip.gsub(/[\r\n]/,'').strip
    paragraph_num = formatted_paragraph[/(?<=paragraph )\d*/].to_i
    paragraph_nums << paragraph_num
  end
end

def paragraph_nums(page)
  all_paragraph_nums(page).uniq.sort
end

def page(link)
  Nokogiri::HTML(open('http://sustainabledevelopment.un.org/'+link+'#un'))
end

def print_entity_paragraph_nums(doc)
  entities(doc).each do |name, link|
    p name
    p paragraph_nums(page(link))
  end
end

doc = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/index.php?menu=1442'))
# print_entity_paragraph_nums(doc)

### Driver Code ###
doc = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/index.php?menu=1442'))
page = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/'+entity_links(doc)[0]+'#un'))
# p paragraph_nums(page) == [24, 38, 47, 54, 62, 66, 68, 78, 84, 91, 93, 100, 106, 108, 109, 133, 137, 154, 156, 179, 182, 185, 186, 243, 244, 248, 251, 280]
# p paragraphs(page)
paragraph = paragraphs(page).first.parent.text.strip
# pry.binding
# paragraph = paragraphs(page).first.parent.text
formatted_paragraph = paragraph.gsub(/[\r\n]/,'').strip
p paragraph_desc = formatted_paragraph[/(?<=-  ).*/]
# paragraphs(page).inject([]) do |paragraph_nums, paragraph|
#   formatted_paragraph = paragraph.text.strip.gsub(/[\r\n]/,'').strip
#   paragraph_num = formatted_paragraph[/(?<=-  ).*/]
#   paragraph_nums << paragraph_num
# end



