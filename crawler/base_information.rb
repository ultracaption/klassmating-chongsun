uri = URI.parse("http://info.nec.go.kr/main/showDocument.xhtml?electionId=0020120411&topMenuId=CP&secondMenuId=CPRI03")
http = Net::HTTP.new(uri.host, uri.port)
begin
  resp = http.get(uri.request_uri)
end while resp.code!="200"
doc = Nokogiri::HTML(resp.body)
parties = Array.new
doc.css("#proportionalRepresentationCode option")[1..-1].each_with_index do |d,i|
  party = Party.create(:number=>i+1, :name=>d.inner_text)
  parties << d.inner_text
  uri2 = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fcp%2Fcpri03.jsp&topMenuId=CP&secondMenuId=CPRI03&menuId=&statementId=CPRI03_%237&electionCode=7&proportionalRepresentationCode="+d["value"])
  begin
    resp2 = http.get(uri2.request_uri)
  end while resp2.code!="200"
  doc2 = Nokogiri::HTML(resp2.body)
  doc2.css("#table01 tbody tr").each do |dd|
    dd = dd.css("td")
    name = dd[4].inner_text.match(/([^\n\t(]*)\(/)[1]
    photo_url = dd[1].inner_html.match(/src="([^"]*)/)[1]
    PartyCandidate.create(:party_id=>party.id, :number=>dd[3].inner_text, :name=>name, :photo_url=>photo_url)
  end
end
uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fcp%2Fcpri06.jsp&topMenuId=CP&secondMenuId=CPRI06&menuId=&statementId=CPRI06_%231&searchType=1&electionCode=2&cityCode=0&maxMinCode=-1&genderCode=0")
begin
  resp = http.get(uri.request_uri)
end while resp.code!="200"
doc = Nokogiri::HTML(resp.body)
doc.css("#table01 tr")[1].css("th")[1..-1].each do |d|
  unless parties.include? d.inner_text
    Party.create(:name=>d.inner_text)
  end
end
uri = URI.parse("http://info.nec.go.kr/bizcommon/selectbox/selectbox_cityCodeBySgJson.json?electionId=0020120411&electionCode=2")
begin
  resp = http.get(uri.request_uri)
end while resp.code!="200"
data = JSON.parse(resp.body)["body"]
data.each do |d|
  abbreviation = d["NAME"][0..5]
  if d["NAME"].match(/남도|북도/)
    abbreviation = d["NAME"][0..2]+d["NAME"][6..8]
  end
  province = Province.create(:name=>d["NAME"], :code=>d["CODE"], :abbreviation=>abbreviation)
  uri2 = URI.parse("http://info.nec.go.kr/bizcommon/selectbox/selectbox_getSggCityCodeJson.json?electionId=0020120411&electionCode=2&cityCode="+d["CODE"].to_s)
  begin
    resp2 = http.get(uri2.request_uri)
  end while resp2.code!="200"
  data2 = JSON.parse(resp2.body)["body"]
  data2.each do |dd|
    abbreviation = dd["NAME"].gsub(/(.)(시|군|구)/,"\\1")
    district = District.create(:province_id=>province.id, :name=>dd["NAME"], :code=>dd["CODE"], :abbreviation=>abbreviation)
    uri3 = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fcp%2Fcpri03.jsp&topMenuId=CP&secondMenuId=CPRI03&menuId=&statementId=CPRI03_%232&electionCode=2&cityCode="+province.code.to_s+"&sggCityCode="+district.code.to_s)
    begin
      resp3 = http.get(uri3.request_uri)
    end while resp3.code!="200"
    doc3 = Nokogiri::HTML(resp3.body)
    doc3.css("#table01 tbody tr").each do |ddd|
      ddd = ddd.css("td")
      party = Party.where(:name=>ddd[3].inner_text).first
      name = ddd[4].inner_text.match(/([^\n\t(]*)\(/)[1]
      photo_url = ddd[1].inner_html.match(/src="([^"]*)/)[1]
      Candidate.create(:district_id=>district.id, :party_id=>party.id, :number=>ddd[2].inner_text, :name=>name, :photo_url=>photo_url)
    end
  end
  uri2 = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fbi%2Fbigi05.jsp&topMenuId=BI&secondMenuId=BIGI&menuId=BIGI05&statementId=BIGI05&electionCode=2&cityCode="+d["CODE"].to_s)
  begin
    resp2 = http.get(uri2.request_uri)
  end while resp2.code!="200"
  doc2 = Nokogiri::HTML(resp2.body)
  district_name = ""
  doc2.css("#table01 tbody tr").each do |dd|
    dd = dd.css("td")
    if (dd[0].inner_text.strip!="")
      district_name = dd[0].inner_text.strip
    end
    district = District.where(:province_id=>province.id, :name=>district_name).first
    region = Region.where(:province_id=>province.id, :name=>dd[1].inner_text).first
    if region.nil?
      region = Region.create(:province_id=>province.id, :name=>dd[1].inner_text)
    end
    Division.create(:region_id=>region.id, :district_id=>district.id)
  end
end
