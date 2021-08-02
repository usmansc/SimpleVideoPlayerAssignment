//
//  Video.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import Foundation

struct Video: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var url: String
    var inoutPoints: [InOutParameter]
}
