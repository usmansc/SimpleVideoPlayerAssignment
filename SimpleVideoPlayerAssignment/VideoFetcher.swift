//
//  VideoFetcher.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import Foundation

class VideoFetcher: ObservableObject {
    @Published var videos: [Video] = []

    init() {
        do {
            if let resource = Bundle.main.path(forResource: "video", ofType: "json") {
                let json = try String(contentsOfFile: resource)
                    do {
                        let decoder = JSONDecoder()
                        let data = Data(json.utf8)
                        let decoded = try decoder.decode([Video].self, from: data)
                        self.videos = decoded
                    } catch {
                        print("Could not parse JSON")
                    }
            }
        } catch {
            print("Could not find resource")
        }
    }
}
