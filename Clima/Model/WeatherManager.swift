import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFairlWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(forCity city : String) {
        let url =  "\(Env.WEATHER_BASE_URL)&q=\(city)";
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string : urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFairlWithError(error: error!)
                }
                if let safeData = data {
                    let weatherData = self.parseJSON(safeData)
                    if let weather = weatherData {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            return weather
        } catch {
            self.delegate?.didFairlWithError(error: error)
            return nil
        }
    }
}
 
