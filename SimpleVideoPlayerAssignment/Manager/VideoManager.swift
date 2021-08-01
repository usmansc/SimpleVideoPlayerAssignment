//
//  VideoManager.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import Foundation

class VideoManager{
    static var shared: VideoManager?
    
    init() {
        VideoManager.shared = self
    }
    
    func fetchVideos() -> [Video]{
        let videoFetcher = VideoFetcher()
        return videoFetcher.videos
    }
    
}
