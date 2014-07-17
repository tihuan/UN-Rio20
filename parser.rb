require 'nokogiri'
require 'open-uri'
require 'pry'

def doc(html)
  Nokogiri::HTML(open(html))
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

def paragraphs(entity_page)
  entity_page.xpath('//b[contains(text(), "In support of Rio+20 outcome paragraph")]')
end

def paragraph_num(paragraph)
  formatted_paragraph = paragraph.text.strip.gsub(/[\r\n]/,'').strip
  formatted_paragraph[/(?<=paragraph )\d*/].to_i
end

def paragraph_desc(paragraph)
  formatted_paragraph = paragraph.parent.text.strip.gsub(/[\r\n]/,'').strip
  paragraph_desc = formatted_paragraph[/(?<=-  ).*/]
end

def all_paragraph_nums(entity_page)
  paragraphs(entity_page).inject([]) do |paragraph_nums, paragraph|
    paragraph_nums << [paragraph_num(paragraph), paragraph_desc(paragraph)]
  end
end

def paragraph_nums(entity_page)
  all_paragraph_nums(entity_page).uniq.sort
end

def entity_page(link)
  Nokogiri::HTML(open('http://sustainabledevelopment.un.org/'+link+'#un'))
end

def print_entity_paragraph_nums(doc)
  entities(doc).each do |name, link|
    puts name
    puts paragraph_nums(entity_page(link))
    puts ""
  end
end

def all_entity_paragraph_nums(doc)
  all_nums = []
  entities(doc).each do |_, link|
    all_nums << paragraph_nums(entity_page(link))
  end
  all_nums.flatten(1).uniq.sort
end

doc = doc('http://sustainabledevelopment.un.org/index.php?menu=1442')
# print_entity_paragraph_nums(doc)
p all_entity_paragraph_nums(doc).count
p all_entity_paragraph_nums(doc)

### Driver Code ###
doc = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/index.php?menu=1442'))
entity_page = Nokogiri::HTML(open('http://sustainabledevelopment.un.org/'+entity_links(doc)[0]+'#un'))
# p paragraph_nums(entity_page) == [24, 38, 47, 54, 62, 66, 68, 78, 84, 91, 93, 100, 106, 108, 109, 133, 137, 154, 156, 179, 182, 185, 186, 243, 244, 248, 251, 280]
# p paragraph_desc(entity_page) == "Establish a universal intergovernmental high level political forum (HLPF), building on the strengths, experiences, resources and inclusive participation modalities of the Commission on Sustainable Development, and subsequently replacing the Commission."
# p paragraphs(entity_page)

paragraph = paragraphs(entity_page).first
# p paragraph_desc(paragraph)




