//
//  MenuManager.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 03/08/2021.
//
// Custom Menu Manager because NavigationLink does not allow to fire action onTap or acts weird

import Foundation
class MenuManager {
    static let shared = MenuManager()
    private var indexOfActiveItem = 0
    private var menuItems = [MenuItem]()

    init() {
        // Make sure to have all options here,
        menuItems = [
            MenuItem(title: "Home", image: "journal", destination: "ContentView", isSelected: false),
            MenuItem(title: "Detail", image: "goals", destination: "DetailView", isSelected: false)
        ]
    }

    /// Use this function to get possible destinations
    /// - Returns: array of items that repersent menu
    func getMenuItems() -> [MenuItem] {
        menuItems
    }

    /// Use this function to select item from menu
    /// - Parameter item: the item we want to activate
    func toggleMenuItem(item: MenuItem) {

        menuItems[indexOfActiveItem].isSelected = false

        if let index = menuItems.firstIndex(where: {$0.id == item.id}) {
            menuItems[index].isSelected.toggle()
            indexOfActiveItem = index

        }
    }
}

/// Make sure this enum is up to date, it should contain all available routes
enum Menu: Int {
    case home = 0
    case detail = 1
}
