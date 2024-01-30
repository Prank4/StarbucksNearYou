//
//  StarbucksViewModel.swift
//  StarbucksNearYou
//
//  Created by Prankur Kamra on 30/01/24.
//

import Foundation

class StarbucksViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var error: Error?
    private let locationManager = LocationManager()
    private let apiKey = "AIzaSyAGUAS_PdmrMVMOQME1h3DNB1HnympnPz0"
    
    init() {
        fetchLocations()
    }
    
    func fetchLocations() {
        guard let userLocation = self.locationManager.userLocation else {
            self.error = NSError(domain: "StarbucksViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch user location"])
            return
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&radius=5000&type=cafe&keyword=starbucks&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            self.error = NSError(domain: "StarbucksViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                self.error = error ?? NSError(domain: "StarbucksViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.locations = result.results.map {
                        Location(name: $0.name, address: $0.vicinity, latitude: $0.geometry.location.lat, longitude: $0.geometry.location.lng)
                    }
                }
            } catch {
                self.error = error
            }
        }.resume()
    }
}
