import Foundation

struct WeatherManager {
    func fetchWeather(forCity city : String) {
        let url =  "\(Env.WEATHER_BASE_URL)&q=\(city)";
        performRequest(withURL: url)
    }
    
    func performRequest(withURL stringURL : String) {
        if let url = URL(string : stringURL) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData : Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            print(weather.temperatureString)
        } catch {
            print(error)
        }
    }
}
 
