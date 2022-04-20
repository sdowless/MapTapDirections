//
//  ContentView.swift
//  MapTapDirections
//
//  Created by Stephen Dowless on 4/18/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var directionEnabled = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            MapViewRepresentable(directionsEnabled: $directionEnabled)
                .ignoresSafeArea()
            
            if directionEnabled {
                Button {
                    print("DEBUG: Remove stuff from map..")
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
