import Foundation
import CoreLocation
import SwiftUI
import UIKit

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature_2m: Double
    let relative_humidity_2m: Int
    let wind_speed_10m: Double
    let precipitation: Double
    let snowfall: Double
    let thunderstorm_probability: Int?
}

enum WeatherCondition: String {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case snowy = "Snowy"
    case thunderstorm = "Thunderstorm"
    case stormy = "Stormy"
    case foggy = "Foggy"
    case veryHot = "Very Hot"
    case hot = "Hot"
    case warm = "Warm"
    case mild = "Mild"
    case cool = "Cool"
    case cold = "Cold"
    case veryCold = "Very Cold"
}

enum WeatherError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case locationError(Error)
    case unknown
    
    var message: String {
        switch self {
        case .invalidURL:
            return """
            Path leads to nowhere
            Digital gates sealed shut tight
            The way is broken
            """
        case .networkError:
            return """
            Silent connection
            Whispers lost in digital
            Mist, await return
            """
        case .decodingError:
            return """
            Numbers turn to ash
            Data writhes, resists our grasp
            Knowledge slips away
            """
        case .locationError:
            return """
            Coordinates lost
            In void between here and there
            The map bleeds shadows
            """
        case .unknown:
            return """
            Ancient error lurks
            Beyond mortal comprehension
            Darkness takes its toll
            """
        }
    }
}

@MainActor
class WeatherService: ObservableObject {
    @Published var currentTemperature: Double?
    @Published var humidity: Int?
    @Published var windSpeed: Double?
    @Published var precipitation: Double?
    @Published var thunderstormProbability: Int?
    @Published var weatherCondition: WeatherCondition?
    @Published var error: WeatherError?
    
    private func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
    private func metersPerSecondToMilesPerHour(_ mps: Double) -> Double {
        return mps * 2.237
    }
    
    private func determineWeatherCondition(temperature: Double, humidity: Int, windSpeed: Double, precipitation: Double, snowfall: Double, thunderstormProbability: Int?) -> WeatherCondition {
        // Thunderstorm conditions take precedence
        if let thunderstormProb = thunderstormProbability, thunderstormProb > 30 {
            return .thunderstorm
        }
        
        // Check precipitation and snowfall
        if snowfall > 0 {
            return .snowy
        } else if precipitation > 0.5 {
            return .rainy
        }
        
        // Temperature-based conditions
        if temperature >= 85 {
            return .veryHot
        } else if temperature >= 70 {
            return .hot
        } else if temperature >= 60 {
            return .warm
        } else if temperature >= 50 {
            return .mild
        } else if temperature >= 40 {
            return .cool
        } else if temperature >= 30 {
            return .cold
        } else {
            return .veryCold
        }
    }
    
    func fetchWeather(for location: CLLocation) async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&current=temperature_2m,relative_humidity_2m,wind_speed_10m,precipitation,snowfall,thunderstorm_probability"
        
        guard let url = URL(string: urlString) else {
            self.error = .invalidURL
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.error = .networkError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                return
            }
            
            let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            let temperature = self.celsiusToFahrenheit(weather.current.temperature_2m)
            let humidity = weather.current.relative_humidity_2m
            let windSpeed = self.metersPerSecondToMilesPerHour(weather.current.wind_speed_10m)
            let precipitation = weather.current.precipitation
            let snowfall = weather.current.snowfall
            let thunderstormProbability = weather.current.thunderstorm_probability
            
            self.currentTemperature = temperature
            self.humidity = humidity
            self.windSpeed = windSpeed
            self.precipitation = precipitation
            self.thunderstormProbability = thunderstormProbability
            self.weatherCondition = self.determineWeatherCondition(
                temperature: temperature,
                humidity: humidity,
                windSpeed: windSpeed,
                precipitation: precipitation,
                snowfall: snowfall,
                thunderstormProbability: thunderstormProbability
            )
            self.error = nil
        } catch let decodingError as DecodingError {
            self.error = .decodingError(decodingError)
        } catch {
            self.error = .networkError(error)
        }
    }
} 
