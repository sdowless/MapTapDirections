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
    @StateObject var viewModel = MapViewModel() 
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // TODO: move directions enabled functionality to view model
            MapViewRepresentable(viewModel: viewModel,
                                 directionsEnabled: $directionEnabled)
                .ignoresSafeArea()
            
            if directionEnabled {
                VStack(alignment: .trailing) {
                    Button {
                        directionEnabled = false 
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
                    
                    List(viewModel.steps, id: \.self) { step in
                        HStack {
                            Text(step.instructions)
                            
                            Spacer()
                            
                            Text(viewModel.distanceInMilesString(forStep: step))
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(width: UIScreen.main.bounds.width, height: 360)
                    .background(Color.white)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
