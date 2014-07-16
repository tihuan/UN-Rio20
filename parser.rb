require 'nokogiri'
require 'open-uri'
require 'pry'

# doc = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/index.php?menu=1442'))
# all_links = doc.css('.frontLink')
# entity_names = all_links.inject([]) { |names, link| names << link.text.strip }
# entity_links = all_links.inject([]) { |links, link| links << link['href'] }
# entities = entity_names.zip(entity_links)
# p "entity names: #{entity_names.count}"
# p entity_names
# p "entity links: #{entity_links.count}"
# p entity_links
# p 'entities'
# p entities
# pry.binding

#unaction67_long

page = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/'+entity_links[0]+'#un'))

def entities(html)
  doc = Nokogiri::HTML(open('html'))
  all_links = doc.css('.frontLink')
  entity_names = all_links.inject([]) { |names, link| names << link.text.strip }
  entity_links = all_links.inject([]) { |links, link| links << link['href'] }
  entities = entity_names.zip(entity_links)
end

def paragraph_nums(page)
  paragraphs = page.xpath('//b[contains(text(), "In support of Rio+20 outcome paragraph")]')
  paragraph_nums = []
  paragraphs.each do |p|
    paragraph = p.text.strip.gsub(/[\r\n-]/,'').strip
    paragraph_nums << paragraph_num = paragraph[/(?<=paragraph ).*/].to_i
  end
  paragraph_nums.uniq.sort
end

p paragraph_nums(page)



