//
//  LocationManager.swift
//  MapBasics
//
//  Created by Ahmed Hamza on 3/7/25.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI
import SwiftUI

class LocationManager: NSObject, ObservableObject{
    
    private var locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var position: MapCameraPosition?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation( )
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        print("📍 New Location: \(lastLocation.coordinate), \(lastLocation.coordinate.longitude)")
        DispatchQueue.main.async {
            self.currentLocation = lastLocation
            self.position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func updateLocation(latitude: Double, longitude: Double) { // manually update based on picker
          
        DispatchQueue.main.async {
            let newLocation = CLLocation(latitude: latitude, longitude: longitude)
            self.currentLocation = newLocation
            self.position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        }

    }

}

extension MapCameraPosition{
    func getBindingForPosition() -> Binding<MapCameraPosition>?{
        return Binding<MapCameraPosition>(.constant(self))
    }
}
