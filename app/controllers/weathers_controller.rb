class WeathersController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token  

  def index
    if params[:location]
      url1 = 'http://api.openweathermap.org/data/2.5'\
            "/weather?q=#{params[:location]}"\
            '&appid=f261d4b9a214e0ea3c3ae99e6c357fb0&units=metric'
      url2 = 'http://api.apixu.com/v1/current.json?'\
              "key=7f0582ae268941a1b2f41827192601&q=#{params[:location]}"
      begin
        @temprature1 = get_temperature(url1)[:main][:temp]
        @temprature2 = get_temperature(url2)[:current][:temp_c]
        @temprature = (@temprature1 + @temprature2) / 2
        Weather.create(city: params[:location], temp: @temprature)
      rescue RestClient::NotFound
        @error = 'Please enter a valid location'
      end
    end
    @weathers = Weather.all
  end

  def get_temperature(url)
    response = RestClient.get url
    eval response.body
  end
end
