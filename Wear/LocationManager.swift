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
            return "Location services are disabled. Please enable them in Settings."
        case .denied:
            return "Location access was denied. Please enable it in Settings."
        case .noLocation:
            return "Unable to determine your location. Please try again."
        case .unknown:
            return "Unable to get your location. Please check your settings."
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var error: LocationError?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        print("Requesting location...")
        
        // Check if location services are enabled
        if !CLLocationManager.locationServicesEnabled() {
            print("Location services are disabled")
            self.error = .servicesDisabled
            return
        }
        
        // Check current authorization status
        let status = locationManager.authorizationStatus
        print("Current authorization status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            print("Authorization not determined, requesting permission")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted")
            self.error = .denied
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access authorized, requesting location")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Unknown authorization status")
            self.error = .unknown
        }
    }
    
    // Called when authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization status changed to: \(manager.authorizationStatus.rawValue)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorization granted, requesting location")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Authorization denied or restricted")
            self.error = .denied
        case .notDetermined:
            print("Authorization not determined")
            // Wait for user response
            break
        @unknown default:
            print("Unknown authorization status")
            self.error = .unknown
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Received location update")
        if let location = locations.last {
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.location = location
            self.error = nil
            locationManager.stopUpdatingLocation()
        } else {
            print("No location received")
            self.error = .noLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied")
                self.error = .denied
            case .locationUnknown:
                print("Location unknown")
                self.error = .noLocation
            default:
                print("Unknown location error")
                self.error = .unknown
            }
        } else {
            print("Non-CLError: \(error.localizedDescription)")
            self.error = .unknown
        }
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
} 