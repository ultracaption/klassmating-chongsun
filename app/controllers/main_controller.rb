# encoding: UTF-8

class MainController < ApplicationController

  layout false

  @@province = %w[서울 경기도 강원도]
  @@region = %w[수원 안양]
  @@district = %w[관악구갑 관악구을]
  @@sort = %w[새누리당오름차순 새누리당내림차순]

  def turnout
    @time = Turnout.where(:index=>19).order(:time).last.time
    @timeval = [7,9,11,12,13,14,15,16,17,18][@time-1]
  end

  def counting
    filter = params[:filter] || ""

    #check route
    if @@province.include? filter
    elsif @@region.include? filter
    elsif @@district.include? filter
    elsif @@sort.include? filter
    else
    end
  end

  def slug
    province_name = params[:slug][0..5]
    @province = Province.where(:abbreviation=>province_name).first
    district_name = params[:slug][6..-1]
    if district_name.nil? or district_name.length==0
      if @province.nil?
        render :text => "없는 지역입니다"
      else
        province
      end
    else
      @district = District.where(:province_id=>@province.id, :abbreviation=>district_name).first
      if @district.nil?
        render :text => "없는 지역구입니다"
      else
        district
      end
    end
  end

  def province
    render :text => @province.name
  end

  def district
    render :text => @district.name
  end

end
