require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/95/avernes.html"))

avernes_email = page.xpath('/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]')
avernes_name = page.xpath('/html/body/div[1]/main/section[1]/div/div/div/p[1]/strong[1]/a')

def get_townhall_email(avernes_email, avernes_name)
  arr1 = []
  arr2 = []

  avernes_email.each do |email|
  arr1 << avernes_email.text
end

avernes_name.each do |name|
  arr2 << avernes_name.text
end

my_hash = arr2.zip(arr1).to_h
  arr3 = my_hash.map {|name,email| {name => email}}
end 
puts get_townhall_email(avernes_email, avernes_name)


#-----------------------------------------------------------------------------

def scrapping_town(url)
  html = URI.open("#{url}").read
  nokogiri_doc = Nokogiri::HTML(html)
  arr = []
  nokogiri_doc.search(".lientxt").each do |element|
      arr << element.attributes["href"].value.gsub("./", "/")
  end
  return arr
end

#--------------------------------------------------------------------------------------
# FONCTION 2 : Concatène les liens de chaque ville (fonction précedente) ---> /95/vaudherland.html
#              avec le lien global ---> https://www.annuaire-des-mairies.com/
#--------------------------------------------------------------------------------------
def find_urls
  towns_link = scrapping_town("https://www.annuaire-des-mairies.com/val-d-oise.html")
  url_list = []
  towns_link.each do |link|
      url_list << "https://www.annuaire-des-mairies.com#{link}"
  end
  return url_list
end

#--------------------------------------------------------------------------------------
# FONCTION 3 : recupère les liens entier de chaque ville, les parse avec nokogiri,
#              puis va chercher le nom et le mail grâce à xpath
#--------------------------------------------------------------------------------------
def final_result(liens)
  link_parse = []
  email_villes = []
  name_villes = []
  #--- Je parse chaque lien et les mets dans un array : link_parse
  liens.each do |lien|
      link_parse << Nokogiri::HTML(URI.open(lien))
  end

  #--- J'intègre le xpath à chaque lien de mon précédent array et les pousse dans 2 arrays distincts
  link_parse.each do |lien|
      email_villes << lien.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
      name_villes << lien.xpath("/html/body/div/main/section[1]/div/div/div/p[1]/strong[1]/a").text
  end

  #--- Je zip mes 2 arrays en 1 seul que je transforme en Hash
  my_hash = Hash[email_villes.zip(name_villes)].to_h 
  info_ville = my_hash.map {|name, email| {email => name}}
  return info_ville
end

puts "Les données chargent ... veuillez patienter."
puts final_result(find_urls)



=begin 
# FONCTION : Récupère chaque lien de chaque ville ---> ex : /95/vaudherland.html
#            Puis on les insère dans un tableau, ici : arr
def scrapping_town(url)
    html = open("#{url}").read
    nokogiri_doc = Nokogiri::HTML(html)
    arr = []
    nokogiri_doc.search(".lientxt").each do |element|
        arr << element.attributes["href"].value.gsub("./", "/")
    end
    return arr
end


# FONCTION : Concatène les liens de chaque ville (fonction précedente) ---> /95/vaudherland.html
#   avec le lien global ---> https://www.annuaire-des-mairies.com/

def find_url
    urls = scrapping_town("https://www.annuaire-des-mairies.com/val-d-oise.html")
    url_list = []
    urls.each do |link|
        url_list << "https://www.annuaire-des-mairies.com#{link}"
    end
    return url_list
end

def result_url(liens)
  link_parse = []
  email_villes = []
  name_villes = []
#--Je parse chaque lien et je les mets dans un array

  liens.each do |lien|
    link_parse << Nokogiri::HTML(URI.open(lien))
  end

#-- J'intègre le xpath à chaque lien de mon précédent array et je les pousses dans 2 différents array
  
  link_parse.each do |lien|
    email_villes << lien.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
    name_villes << lien.xpath("/html/body/div[1]/main/section[1]/div/div/div/p[1]/strong[1]/a").text
  end

#-- Faire un hash des deux
  final_hash = name_villes.zip(email_villes).to_h
  arr_3 = final_hash.map {|name,email| {name => email}}
  return arr_3
end

result_url(find_url)


=end







=begin
def get_townhall_email(url, name)
    arr = []
    email = url.text
    ville = name.text
    hash = {
        "#{ville}" => "#{email}",
    }
    arr << hash
    return arr
end

get_townhall_email(email_avernes, name_avernes)

=end
