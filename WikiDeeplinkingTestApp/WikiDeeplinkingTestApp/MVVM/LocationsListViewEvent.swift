//
//  LocationsListViewEvent.swift
//  WikiDeeplinkingTestApp
//
//  Created by Vladyslav Kornieiev on 10/19/23.
//

enum LocationsListViewEvent {
    case onAppear
    case onOpen(LocationItem)
    case onEdit
    case onAdd(LocationItem)
    case onCancel
}
