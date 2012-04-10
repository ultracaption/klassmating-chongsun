# encoding: UTF-8

class MainController < ApplicationController

  layout false

  @@province = %w[서울 경기도 강원도]
  @@region = %w[수원 안양]
  @@district = %w[관악구갑 관악구을]
  @@sort = %w[새누리당오름차순 새누리당내림차순]

  def turnout

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

end
