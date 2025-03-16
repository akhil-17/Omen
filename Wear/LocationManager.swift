import CoreLocation
import SwiftUI
import UIKit

enum LocationError: Error {
    case servicesDisabled
    case denied
    case unknown
    case noLocation
    
    var message: String {
        switch self {
        case .servicesDisabled:
            return "Settings lie dormant\nLocation sleeps in darkness\nWake it from its rest"
        case .denied:
            return "Permission withheld\nLike a door sealed against truth\nOpen it once more"
        case .noLocation:
            return "Where are you, wanderer?\nThe void claims your coordinates\nTry again, and seek"
        case .unknown:
            return "Mystery deepens\nLocation lost in shadows\nCheck your settings now"
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var error: LocationError?
    @Published var permissionStatus: CLAuthorizationStatus
    
    override init() {
        self.permissionStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        // Check if location services are enabled
        if !CLLocationManager.locationServicesEnabled() {
            self.error = .servicesDisabled
            return
        }
        
        // Check current authorization status
        let status = locationManager.authorizationStatus
        self.permissionStatus = status
        
        switch status {
        case .notDetermined:
            self.error = .denied
        case .restricted, .denied:
            self.error = .denied
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            self.error = .unknown
        }
    }
    
    // Called when authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.permissionStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.error = nil
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.error = .denied
        case .notDetermined:
            // Wait for user response
            break
        @unknown default:
            self.error = .unknown
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            self.error = nil
            locationManager.stopUpdatingLocation()
        } else {
            self.error = .noLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                self.error = .denied
            case .locationUnknown:
                self.error = .noLocation
            default:
                self.error = .unknown
            }
        } else {
            self.error = .unknown
        }
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
} 