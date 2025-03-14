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
    let thunderstorm_probability: Int?
}

enum WeatherCondition: String {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
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
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .thunderstorm: return "cloud.bolt.fill"
        case .stormy: return "cloud.bolt.rain.fill"
        case .foggy: return "cloud.fog.fill"
        case .veryHot: return "thermometer.high"
        case .hot: return "thermometer.high"
        case .warm: return "thermometer"
        case .mild: return "thermometer"
        case .cool: return "thermometer"
        case .cold: return "thermometer.low"
        case .veryCold: return "thermometer.low"
        }
    }
}

enum WeatherError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case locationError(Error)
    case unknown
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
    
    private func determineWeatherCondition(temperature: Double, humidity: Int, windSpeed: Double, precipitation: Double, thunderstormProbability: Int?) -> WeatherCondition {
        // Thunderstorm conditions take precedence
        if let thunderstormProb = thunderstormProbability, thunderstormProb > 30 {
            return .thunderstorm
        }
        
        // Temperature-based conditions with humidity and wind consideration
        let feelsLikeTemperature = calculateFeelsLikeTemperature(
            temperature: temperature,
            humidity: humidity,
            windSpeed: windSpeed,
            precipitation: precipitation
        )
        
        if feelsLikeTemperature >= 100 {
            return .veryHot
        } else if feelsLikeTemperature >= 90 {
            return .hot
        } else if feelsLikeTemperature >= 80 {
            return .warm
        } else if feelsLikeTemperature >= 70 {
            return .mild
        } else if feelsLikeTemperature >= 60 {
            return .cool
        } else if feelsLikeTemperature >= 32 {
            return .cold
        } else {
            return .veryCold
        }
    }
    
    private func calculateFeelsLikeTemperature(temperature: Double, humidity: Int, windSpeed: Double, precipitation: Double) -> Double {
        let humidityFactor = Double(humidity) / 100.0
        let windFactor = windSpeed * 0.1 // Wind speed impact factor
        let precipitationFactor = min(precipitation * 2.0, 10.0) // Precipitation impact factor, capped at 10°F
        
        // Calculate base temperature with humidity and wind
        let baseTemperature: Double
        if temperature >= 80 {
            // Heat index calculation for warm temperatures
            let temperatureFactor = temperature - 80.0
            let heatIndex = temperature + (humidityFactor * temperatureFactor * 0.1)
            baseTemperature = heatIndex - (windFactor * (temperature - 80) * 0.05)
        } else {
            // Wind chill calculation for cold temperatures
            let temperatureFactor = 80.0 - temperature
            let baseChill = temperature - (humidityFactor * temperatureFactor * 0.05)
            baseTemperature = baseChill - (windFactor * temperatureFactor * 0.1)
        }
        
        // Apply precipitation effect
        if precipitation > 0 {
            // Rain makes it feel colder due to evaporative cooling
            // The effect is stronger at higher temperatures
            let rainEffect = precipitationFactor * (1.0 + (temperature - 50) * 0.02)
            return baseTemperature - rainEffect
        }
        
        return baseTemperature
    }
    
    func fetchWeather(for location: CLLocation) async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&current=temperature_2m,relative_humidity_2m,wind_speed_10m,precipitation,thunderstorm_probability"
        
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
