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
    @StateObject var viewModel: MapViewModel
    @Binding var directionsEnabled: Bool
    
    // we make this a class level property to access it from anywhere in this class
    private let mapView = MKMapView()
    
    func makeUIView(context: Context) -> some UIView {
        // configure map view
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let userLocation = locationManager.userLocation else { return }
        
        if !directionsEnabled {
            context.coordinator.centerMapOnUserLocation(userLocation)
            context.coordinator.removeAnnotationsAndOverlays()
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
            
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        private let parent: MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
            
            
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(handleMapTapped))
            parent.mapView.addGestureRecognizer(tap)
        }
        
        func centerMapOnUserLocation(_ userLocation: CLLocation) {
            let coordinates = userLocation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            self.parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let overlay = MKPolylineRenderer(overlay: overlay)
            overlay.strokeColor = .systemBlue
            overlay.lineWidth = 6
            return overlay
        }

        @objc func handleMapTapped(sender: UITapGestureRecognizer) {
            print("DEBUG: Did tap map..")
            print("DEBUG: Sender location is \(sender.location(in: parent.mapView))")
            let tappedLocation = sender.location(in: parent.mapView)
            let mapLocationCoordinates = parent.mapView.convert(tappedLocation, toCoordinateFrom: parent.mapView)
            print("DEBUG: Map location is \(mapLocationCoordinates)")
            
            addAnnotationAndGeneratePolyline(forCoordinate: mapLocationCoordinates)
        }
        
        func addAnnotationAndGeneratePolyline(forCoordinate coordinate: CLLocationCoordinate2D) {
            removeAnnotationsAndOverlays()
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            
            let placemark = MKPlacemark(coordinate: coordinate)
            generatePolyline(forPlacemark: placemark)
        }
        
        func generatePolyline(forPlacemark destinationPlacemark: MKPlacemark) {
            guard let userLocation = parent.locationManager.userLocation else { return }
            let userPlacemark = MKPlacemark(coordinate: userLocation.coordinate)
                        
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            
            let directions = MKDirections(request: request)
                        
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else { return }
                let polyline = route.polyline
                self.parent.mapView.addOverlay(polyline)
                
                route.steps.forEach { step in
                    print("DEBUG: In \(step.distance) \(step.instructions)")
                    self.parent.viewModel.setSteps(route.steps)
                }
                
                self.setRegion(forPolyline: polyline)
                self.parent.directionsEnabled = true
            }
        }
        
        func removeAnnotationsAndOverlays() {
            if self.parent.mapView.overlays.count > 0 {
                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
            }
            
            if self.parent.mapView.annotations.count > 0 {
                self.parent.mapView.removeAnnotations(self.parent.mapView.annotations)
            }
        }
        
        func setRegion(forPolyline polyline: MKPolyline) {
            let rect = self.parent.mapView.mapRectThatFits(polyline.boundingMapRect,
                                                           edgePadding: .init(top: 16, left: 16, bottom: 380, right: 16))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}
