import Foundation
import CoreLocation
import WidgetKit

@Observable
class SharedWeatherData {
    static let shared = SharedWeatherData()
    private let userDefaults = UserDefaults(suiteName: "group.com.akhildakinedi.omen")
    
    var currentHaiku: String {
        get {
            return userDefaults?.string(for: .currentHaiku) ?? "Through mist and shadow\nYour presence calls to the void\nShare your location"
        }
        set {
            userDefaults?.set(newValue, forKey: UserDefaultsKey.currentHaiku.rawValue)
            lastUpdated = Date()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    var lastUpdated: Date {
        get {
            return userDefaults?.date(for: .lastUpdated) ?? Date()
        }
        set {
            userDefaults?.set(newValue, forKey: UserDefaultsKey.lastUpdated.rawValue)
        }
    }
    
    private init() {}
}

enum UserDefaultsKey: String {
    case currentHaiku
    case lastUpdated
}

extension UserDefaults {
    func string(for key: UserDefaultsKey) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func date(for key: UserDefaultsKey) -> Date? {
        return object(forKey: key.rawValue) as? Date
    }
} 