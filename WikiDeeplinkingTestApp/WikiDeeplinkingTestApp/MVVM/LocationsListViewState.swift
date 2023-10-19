//
//  LocationsListViewState.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import Foundation

enum LocationsListViewState {
    case loading
    case loaded([LocationItem])
    case editing([LocationItem])
    
    var items: [LocationItem] {
        switch self {
        case .loading:
            return []
        case let .loaded(items),
             let .editing(items):
            return items
        }
    }
    
    var isEditing: Bool {
        switch self {
        case .editing:
            return true
        default:
            return false
        }
    }
}

struct LocationItem: Identifiable {
    let id = UUID()
    let name: String?
    let lat: Double
    let long: Double
}
