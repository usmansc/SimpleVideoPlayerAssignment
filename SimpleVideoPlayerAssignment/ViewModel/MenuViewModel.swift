//
//  MenuViewModel.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 03/08/2021.

// view model that bridges menu view and menu manager

import Foundation
import SwiftUI
import UIKit
import CoreData

final class MenuViewModel: ObservableObject {
    @Published var items = [MenuItem]()
    @Published var selected: Int = 0
    @Published var isToggled: Bool = false
    @Published var titleSelected = false
    @Published var title: String = ""
    @Published var terrainSelection = 0
    @Published var refresh = false
    var previousItem: MenuItem?
    var dataManager: MenuManager

    init(dataManager: MenuManager = MenuManager.shared) {

        self.dataManager = dataManager
        getItems()

    }

    /// Use this function to get items that we want to display in the menu
    func getItems() {
        items = dataManager.getMenuItems()
    }

    /// Use this function to select item in menu
    /// This allows us to move between views
    func selectItem(which item: MenuItem) {
        if item.destination != "MainSettingsView" && item.destination != "WorkoutDetailView"{
            previousItem = item
        }
        dataManager.toggleMenuItem(item: item)
        if let index = items.firstIndex(where: {$0.id == item.id}) {
            self.selected = index
            self.title = item.title
            if title != "Home"{
                titleSelected = true
            } else {
                titleSelected = false
            }
        }
        getItems()
        self.isToggled.toggle()
    }
}

enum Item: Int {
    case home = 0
    case detail = 1
}
