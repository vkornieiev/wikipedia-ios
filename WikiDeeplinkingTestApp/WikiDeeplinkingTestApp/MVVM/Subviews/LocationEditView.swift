//
//  LocationEditView.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

import SwiftUI

struct LocationEditView: View {
    @State var name: String = ""
    @State var latitude: Double?
    @State var longitude: Double?
    
    var onSubmit: (LocationItem) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Please enter a place details:")
            Group {
                TextField("Name (optional)", text: $name)
                TextField("Latitude (e.g. 40.25)", value: $latitude, format: .number)
                TextField("Longitude (e.g. 38.25)", value: $longitude, format: .number)
            }
            .textFieldStyle(.roundedBorder)
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .buttonStyle(.bordered)
                Spacer()
                Button("Confirm") {
                    guard let latitude = latitude, let longitude = longitude else { return }
                    let item = LocationItem(name: name.isEmpty ? nil : name,
                                            lat: latitude,
                                            long: longitude)
                    onSubmit(item)
                }
                .disabled(latitude == nil || longitude == nil)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct LocationEditView_Previews: PreviewProvider {
    static var previews: some View {
        LocationEditView(onSubmit: {_ in}, onCancel: {})
    }
}
