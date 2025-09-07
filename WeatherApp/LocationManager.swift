//
//  LocationManager.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 7/15/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var city: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  // Ask for permission
        locationManager.startUpdatingLocation()          // Start getting location
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let cityName = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    self?.city = cityName
                    self?.locationManager.stopUpdatingLocation() // فقط یه بار بخون
                }
            }
        }
    }
}

