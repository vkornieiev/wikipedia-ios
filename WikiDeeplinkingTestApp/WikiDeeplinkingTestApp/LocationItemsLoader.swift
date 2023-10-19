//
//  Location.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import Foundation

struct LocationItemsLoader {
    static let locationsUrlString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    static func fetch() async throws -> LocationsDataResponse {
        guard let url = URL(string: locationsUrlString) else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnsupportedURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(LocationsDataResponse.self, from: data)
    }
}

struct LocationsDataResponse: Codable {
    struct LocationItem: Codable, Hashable {
        let name: String?
        let lat: Double
        let long: Double
    }
    let locations: [LocationItem]
}


