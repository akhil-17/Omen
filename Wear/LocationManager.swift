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
        print("Requesting permission...")
        locationManager.requestWhenInUseAuthorization()
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
        self.permissionStatus = status
        
        switch status {
        case .notDetermined:
            print("Authorization not determined")
            self.error = .denied
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
        self.permissionStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorization granted, requesting location")
            self.error = nil
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