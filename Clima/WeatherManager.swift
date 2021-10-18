import Foundation

struct WeatherManager {
    func weatherURL(forCity city : String) -> String {
        return "\(Env.WEATHER_BASE_URL)&q=\(city)";
    }
}
