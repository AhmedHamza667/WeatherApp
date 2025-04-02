//
//  ContentView.swift
//  MapBasics
//
//  Created by Ahmed Hamza on 3/7/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var staticRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(33.88155, -84.505745), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @StateObject var locationManager = LocationManager()
    var dynamicPosition:Binding<MapCameraPosition>?{
        guard let location = locationManager.currentLocation else { return MapCameraPosition.region(staticRegion).getBindingForPosition()
        }
        let position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        return position.getBindingForPosition()
        
    }
    
    var body: some View {
        ZStack {
            //Map(coordinateRegion: $staticRegion)
            if let position = dynamicPosition, let currentLocation =  locationManager.currentLocation {
                Map(position: position){
                    Marker("My locatiom", coordinate: currentLocation.coordinate)
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(locationManager.$currentLocation) { newLocation in
                    if let location = newLocation {
                        staticRegion = MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                        print("🗺️ Map Updated to: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    }
                }
    }
}

#Preview {
    MapView()
}
