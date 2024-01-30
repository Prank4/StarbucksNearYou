//
//  StarbucksLocation.swift
//  StarbucksNearYou
//
//  Created by Prankur Kamra on 30/01/24.
//

import SwiftUI
import MapKit

struct StarbucksLocation: View {
    @ObservedObject var viewModel: StarbucksViewModel
    @Binding var selectedLocation: Location?
    @Binding var showMap: Bool
    
    var body: some View {
        List(viewModel.locations) { location in
            Button(action: {
                selectedLocation = location
                showMap.toggle()
            }) {
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.headline)
                    Text(location.address)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Starbucks Locations")
        .onAppear {
            viewModel.fetchLocations()
        }
    }
}

struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @Binding var selectedLocation: Location?
    
    var body: some View {
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: selectedLocation?.latitude ?? 0.0, longitude: selectedLocation?.longitude ?? 0.0),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        ),
            showsUserLocation: true,
            annotationItems: [selectedLocation].compactMap { $0 }
        ) { location in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .blue)
        }
    }
}



#Preview {
    StarbucksLocation(viewModel: .init(), selectedLocation: .constant(.none), showMap: .constant(.random()))
}
