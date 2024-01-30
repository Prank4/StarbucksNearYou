//
//  LocationResponseModel.swift
//  StarbucksNearYou
//
//  Created by Prankur Kamra on 30/01/24.
//

import Foundation

struct GooglePlacesResponse: Decodable {
    let results: [GooglePlace]
}

struct GooglePlace: Decodable {
    let name: String
    let vicinity: String
    let geometry: Geometry
}

struct Geometry: Decodable {
    let location: LocationCoordinate
}

struct LocationCoordinate: Decodable {
    let lat: Double
    let lng: Double
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}
