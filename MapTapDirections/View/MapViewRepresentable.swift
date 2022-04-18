//
//  MapViewRepresentable.swift
//  MapTapDirections
//
//  Created by Stephen Dowless on 4/18/22.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    
    // we make this a class level property to access it from anywhere in this class
    private let mapView = MKMapView()
    
    func makeUIView(context: Context) -> some UIView {
        // configure map view
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let userLocation = locationManager.userLocation {
            let coordinates = userLocation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator()
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject {
        
        
        
    }
}
