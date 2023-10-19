//
//  WikiLinksBuilder.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import Foundation

struct WikiLinkBuilder {
    static let wikiAppScheme = "wikipedia"
    static let wikiAppPlacesHost = "places"
    static func placeDeeplinkUrl(title: String?, latitude: Double, longitude: Double) throws -> URL {
        var components = URLComponents()
        components.scheme = wikiAppScheme
        components.host = wikiAppPlacesHost
        components.queryItems = [
            .init(name: "title", value: title),
            .init(name: "lat", value: String(latitude)),
            .init(name: "long", value: String(longitude))
        ]
        
        guard let url = components.url else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotFindHost)
        }
        
        return url
    }
}
