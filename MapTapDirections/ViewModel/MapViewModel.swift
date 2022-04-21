//
//  MapViewModel.swift
//  MapTapDirections
//
//  Created by Stephen Dowless on 4/20/22.
//

import MapKit


class MapViewModel: ObservableObject {
    @Published var steps = [MKRoute.Step]()
    
    func setSteps(_ steps: [MKRoute.Step]) {
        self.steps = steps.filter({ $0.distance > 0 })
    }
    
    func distanceInMilesString(forStep step: MKRoute.Step) -> String {
        let distanceInMiles = step.distance / 1609
        var distanceInFeet = 0.0
        
        let formatter = NumberFormatter()
        
        if distanceInMiles <= 0.1 {
            distanceInFeet = distanceInMiles * 5280.0
        }
        
        formatter.numberStyle = distanceInFeet == 0 ? .decimal : .none
        formatter.maximumFractionDigits = distanceInFeet == 0 ? 2 : 0
        
        let distanceValue = distanceInFeet == 0 ? distanceInMiles : distanceInFeet
        guard let distanceValueString = formatter.string(for: distanceValue) else { return "" }
        let unit = distanceInFeet == 0 ? "mi" : "ft"
        
        return "\(distanceValueString) \(unit)"
    }
}
