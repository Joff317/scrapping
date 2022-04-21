require_relative "../lib/mairie_christmas"

#--- VARIABLES --
url = "https://www.annuaire-des-mairies.com/val-d-oise.html"

#---TEST

describe "the find_url method" do
  it "should return count of find_url method" do
    expect(find_urls.count).to eq(185)
    expect(find_urls.count > 120).to eq(true)
  end
end


describe "the find_url method" do
  it "should return a city of the list" do
    expect(find_urls.include?("https://www.annuaire-des-mairies.com/95/aincourt.html")).to eq(true)
    expect(find_urls.include?("https://www.annuaire-des-mairies.com/95/seugy.html")).to eq(true)
    expect(find_urls.include?("https://www.annuaire-des-mairies.com/95/chaumontel.html")).to eq(true)
  end
end


describe "the scraping_town(url) methode" do 
  it "should return the end of the url of a city page" do
    expect(scrapping_town(url).include?("/95/jagny-sous-bois.html")).to eq(true)
  end
end
