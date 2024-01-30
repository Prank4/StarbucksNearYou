//
//  ContentView.swift
//  StarbucksNearYou
//
//  Created by Prankur Kamra on 30/01/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var viewModel = StarbucksViewModel()
    @State private var selectedLocation: Location?
    @State private var showMap = false
    
    var body: some View {
        NavigationView {
            VStack {
                if !showMap {
                    StarbucksLocation(viewModel: viewModel, selectedLocation: $selectedLocation, showMap: $showMap)
                } else {
                    MapView(selectedLocation: $selectedLocation)
                        .navigationTitle(selectedLocation?.name ?? "Starbucks Location")
                        .navigationBarItems(trailing:
                                                Button("List View") {
                            showMap.toggle()
                        }
                        )
                        .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
