//
//  SimpleVideoPlayerAssignmentApp.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import SwiftUI

@main
struct SimpleVideoPlayerAssignmentApp: App {
    @StateObject var detailViewModel: DetailViewModel = DetailViewModel()
    @StateObject var menuViewModel = MenuViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(detailViewModel).environmentObject(menuViewModel)
        }
    }
}
