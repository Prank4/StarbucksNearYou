//
//  LocationManager.swift
//  StarbucksNearYou
//
//  Created by Prankur Kamra on 30/01/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var authorizationStatusString: String = ""
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        
#if targetEnvironment(simulator)
        self.userLocation = CLLocation(latitude: 28.457523, longitude: 77.026344)
#endif
    }
    
    func requestLocationAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            self.userLocation = CLLocation(latitude: 28.457523, longitude: 77.026344)
            return
        }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.authorizationStatusString = "Authorized"
            print("Location access granted")
            // Handle location access granted
        case .denied:
            self.authorizationStatusString = "Denied"
            print("Location access denied")
            // Handle location access denied
        case .notDetermined:
            self.authorizationStatusString = "Not Determined"
            print("Location access not determined")
            // Handle location access not determined
        case .restricted:
            self.authorizationStatusString = "Restricted"
            print("Location access restricted")
            // Handle location access restricted
        @unknown default:
            self.authorizationStatusString = "Unknown"
            print("Unknown location authorization status")
        }
    }
}
