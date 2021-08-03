//
//  MenuItem.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 03/08/2021.
//

import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    var title: String
    var image: String
    var destination: String
    var isSelected = false
}
