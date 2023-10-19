//
//  LocationsListViewModel.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import Combine
import UIKit.UIApplication

@MainActor
final class LocationsListViewModel: ObservableObject {
    @Published var state: LocationsListViewState = .loading
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert == false {
                errorMessage = nil
            }
        }
    }
    var errorMessage: String?
    
    func handle(_ event: LocationsListViewEvent) {
        switch event {
        case .onAppear:
            loadContent()
        case let .onOpen(item):
            tryOpenWikipediaPlace(by: item)
        case .onEdit:
            state = .editing(state.items)
        case let .onAdd(item):
            var items = state.items
            items.append(item)
            state = .loaded(items)
        case .onCancel:
            state = .loaded(state.items)
        }
    }
    
    private func loadContent() {
        Task {
            do {
                let locationsData = try await LocationItemsLoader.fetch()
                let items = locationsData.locations.map { LocationItem(name: $0.name, lat: $0.lat, long: $0.long) }
                state = .loaded(items)
                errorMessage = nil
            } catch {
                state = .loaded([])
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    private func tryOpenWikipediaPlace(by item: LocationItem) {
        do {
            let url = try WikiLinkBuilder.placeDeeplinkUrl(title: item.name,
                                                       latitude: item.lat,
                                                       longitude: item.long)
            UIApplication.shared.open(url) { [weak self] success in
                if !success {
                    self?.errorMessage = "Wikipedia app is not installed or not available at this moment"
                    self?.showAlert = true
                }
            }
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
}
