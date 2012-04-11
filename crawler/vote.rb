http = Net::HTTP.new("info.nec.go.kr", 80)
http2 = Net::HTTP.new("2012.ultracaption.net", 80)
district_packet = ""
party_packet = ""
uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fvc%2Fvccp09.jsp&topMenuId=VC&secondMenuId=VCCP&menuId=VCCP09&statementId=VCCP09_%237&electionCode=7&cityCode=0&sggCityCode=0")
begin
  resp = http.get(uri.request_uri)
end while resp.code!="200"
doc = Nokogiri::HTML(resp.body)
province_name = ""
doc.css("#table01 tbody tr")[2..-1].each_with_index do |d,i|
  d = d.css("td")
  time = Time.now.to_i/600
  if i < 2 
    province_name = ""
  elsif i%2==0
    province_name = Province.where(:name=>d[0].inner_text.strip).first.name
  end
  if i%2==0
    parties = Party.where('number<=10')
    offset = 3
  else
    parties = Party.where('number>=11')
    offset = 0
  end
  parties.each_with_index do |p,i|
    count = d[i+offset].inner_text.match(/([^(]*)/)[1].gsub(",","")
    party_packet += "#{time}%2C#{province_name}%2C%2C#{p.name}%2C#{count}%7C"
#http2.post("/ip","time=#{time}&province=#{province_name}&region=&party=#{p.name}&count=#{count}")
  end
end
http2.post("/ip","packet="+party_packet)
party_packet = ""
Province.all.each do |p|
  puts p.name+" processing"
  uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fvc%2Fvccp09.jsp&topMenuId=VC&secondMenuId=VCCP&menuId=VCCP09&statementId=VCCP09_%232&electionCode=2&cityCode="+p.code+"&sggCityCode=0")
  begin
    resp = http.get(uri.request_uri)
  end while resp.code!="200"
  doc = Nokogiri::HTML(resp.body)
  district = nil
  doc.css("#table01 tbody tr").each do |d|
    d = d.css("td")
    time = Time.now.to_i/600
    if d[0].inner_text.strip == "" and district
      if district.total_count.nil?
        total_count = d[1].inner_text.match(/([^(]*)/)[1].gsub(",","")
        voter_count = d[2].inner_text.match(/([^(]*)/)[1].gsub(",","")
        district.update_attributes(:total_count=>total_count, :voter_count=>voter_count)
      end
      Candidate.where(:district_id=>district.id).order(:number).each_with_index do |c,i|
        count = d[i+3].inner_text.match(/([^(]*)/)[1].gsub(",","")
#     DistrictVote.create(:time=>time, :district_id=>district.id, :candidate_id=>c.id, :count=>count)
#http2.post("/id","time=#{time}&province=#{p.name}&district=#{district.name}&candidate=#{c.name}&count=#{count}")
        district_packet += "#{time}%2C#{p.name}%2C#{district.name}%2C#{c.name}%2C#{count}%7C"
      end
      district = nil
    else
      district = District.where(:province_id=>p.id, :name=>d[0].inner_text.strip).first
    end
  end
  http2.post("/id","packet="+district_packet)
  district_packet = ""
  uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.xhtml?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fvc%2Fvccp09.jsp&topMenuId=VC&secondMenuId=VCCP&menuId=VCCP09&statementId=VCCP09_%237&electionCode=7&cityCode="+p.code+"&sggCityCode=0")
  region = nil
  begin
    resp = http.get(uri.request_uri)
  end while resp.code!="200"
  doc = Nokogiri::HTML(resp.body)
  doc.css("#table01 tbody tr")[4..-1].each_with_index do |d,i|
    d = d.css("td")
    time = Time.now.to_i/600
    if i%2==0
      parties = Party.where('number<=10')
      offset = 3
      region = Region.where(:province_id=>p.id, :name=>d[0].inner_text.strip).first
    else
      parties = Party.where('number>=11')
      offset = 0
    end
    parties.each_with_index do |pp,i|
      count = d[i+offset].inner_text.match(/([^(]*)/)[1].gsub(",","")
#      PartyVote.create(:time=>time, :region_id=>region.id, :party_id=>p.id, :count=>count)
#http2.post("/ip","time=#{time}&province=#{p.name}&region=#{region.name}&party=#{pp.name}&count=#{count}")
      party_packet += "#{time}%2C#{p.name}%2C#{region.name}%2C#{pp.name}%2C#{count}%7C"
    end
  end
  http2.post("/ip","packet="+party_packet)
  party_packet = ""
end

