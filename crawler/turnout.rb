uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.action?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fvc%2Fvcvp01.jsp&topMenuId=VC&secondMenuId=VCVP&menuId=VCVP01&statementId=VCVP01_%231&cityCode=0&timeCode=0")
http = Net::HTTP.new(uri.host, uri.port)
resp = http.get(uri.request_uri)
doc = Nokogiri::HTML(resp.body)
doc.css("#table01 tbody tr").each_with_index do |d,i|
  d = d.css("td")
  if i == 0
    province_id = 0
  else
    province_id = Province.where(:name=>d[0].inner_text.strip).first.id
  end
  total = d[1].inner_text.match(/([^(]*)/)[1].gsub(",","")
  voter_count = 0
  time = 10
  while true do
    voter_count = d[time+1].inner_text.match(/([^(]*)/)[1].gsub(",","")
    break if voter_count!="0" or time==1
    time -= 1
  end
  if Turnout.where(:time=>time, :province_id=>province_id, :region_id=>0, :index=>19).count==0
    Turnout.create(:time=>time, :province_id=>province_id, :region_id=>0, :rate=>voter_count.to_f/total.to_f, :index=>19)
  end
end
Province.all.each do |p|
  uri = URI.parse("http://info.nec.go.kr/electioninfo/electionInfo_report.action?electionId=0020120411&requestURI=%2Felectioninfo%2F0020120411%2Fvc%2Fvcvp01.jsp&topMenuId=VC&secondMenuId=VCVP&menuId=VCVP01&statementId=VCVP01_%232&cityCode="+p.code+"&timeCode=0")
  begin
    resp = http.get(uri.request_uri)
  end while resp.code!="200"
  doc = Nokogiri::HTML(resp.body)
  doc.css("#table01 tbody tr")[1..-1].each do |d|
    d = d.css("td")
    region = Region.where(:province_id=>p.id, :name=>d[0].inner_text.strip).first
    total_count = d[1].inner_text.match(/([^(]*)/)[1].gsub(",","")
    voter_count = 0
    time = 10
    while true do
      voter_count = d[time+1].inner_text.match(/([^(]*)/)[1].gsub(",","")
      break if voter_count!="0" or time==1
      time -= 1
    end
    region.update_attributes(:total_count=>total_count, :voter_count=>voter_count)
    if Turnout.where(:time=>time, :province_id=>region.province_id, :region_id=>region.id, :index=>19).count==0
      Turnout.create(:time=>time, :province_id=>region.province_id, :region_id=>region.id, :rate=>voter_count.to_f/total_count.to_f, :index=>19)
    end
  end
end
