//
//  LocationManager.swift
//  MapTapDirections
//
//  Created by Stephen Dowless on 4/18/22.
//

import CoreLocation

/*
 Location Manager class is responsible for requesting access to user location
 and storing the user location in a value that can be accessed across the app
*/

class LocationManager: NSObject, ObservableObject {
    let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.userLocation = manager.location
        print("DEBUG: Did init")
        print("DEBUG: Location in init block is \(userLocation)")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: Not determined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use")
            guard let location = manager.location else { return }
            self.userLocation = location
            print("DEBUG: Location in did change status block is \(userLocation)")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("DEBUG: Did update locations \(locations)")
        guard let location = locations.last else { return }
//        print("DEBUG: User location is \(location)")
        self.userLocation = location
    }
}
