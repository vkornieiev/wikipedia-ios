//
//  LocationsListView.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import SwiftUI

struct LocationsListView: View {
    @StateObject var viewModel = LocationsListViewModel()

    var body: some View {
        mainContent
        .onAppear {
            viewModel.handle(.onAppear)
        }
        .alert("Oops.\nSomething went wrong",
               isPresented: $viewModel.showAlert,
               presenting: viewModel.errorMessage,
               actions: { _ in },
               message: { message in
            viewModel.errorMessage.map {
                Text($0)
            }
        })
    }
    
    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.state {
        case .loading:
            ProgressView {
                Text("We're looking for locations...")
            }
        case .loaded, .editing:
            List {
                itemsSection
                newEntrySection
            }
        }
    }
    
    @ViewBuilder
    private var itemsSection: some View {
        Section {
            ForEach(viewModel.state.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        if let name = item.name {
                            Text(name)
                                .bold()
                        } else {
                            Text("(no name)")
                                .foregroundColor(.gray).opacity(0.5)
                                .italic()
                        }
                        Text("lat: \(item.lat)")
                        Text("long: \(item.long)")
                    }
                    Spacer()
                    Button {
                        viewModel.handle(.onOpen(item))
                    } label: {
                        Text("View in Wikipedia")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var newEntrySection: some View {
        Section {
            if viewModel.state.isEditing {
                LocationEditView { item in
                    viewModel.handle(.onAdd(item))
                } onCancel: {
                    viewModel.handle(.onCancel)
                }
                .id(UUID())
            } else {
                Button {
                    withAnimation {
                        viewModel.handle(.onEdit)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add my place")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
    }
}
