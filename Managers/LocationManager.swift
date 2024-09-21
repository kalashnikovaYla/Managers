//
//  LocationManager.swift
//  Managers
//
//  Created by Юлия  on 21.09.2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject,  CLLocationManagerDelegate {
    var location: CLLocation?  
    var status: CLAuthorizationStatus = .notDetermined
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        locationStatus()
    }
    
    func requestLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
           locationManager.delegate = self
           locationManager.requestWhenInUseAuthorization()
        }
       
        DispatchQueue.global(qos: .userInitiated).async {
            self.locationManager.requestLocation()
        }
    }
    
    func locationStatus() {
        DispatchQueue.global(qos: .userInteractive).async {
            if CLLocationManager.locationServicesEnabled() {
                self.status = CLLocationManager.authorizationStatus()
            } else {
                print("Геолокация отключена")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}


