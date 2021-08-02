//
//  DetailViewModel.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import AVKit

final class DetailViewModel: ObservableObject{
    let videoManager: VideoManager
    @Published var inOutZones: [InOutParameter] = []
    @Published var chosenVideo: Video = Video(id: -1, name: "", url: "", inoutPoints: [])
    @Published var videos: [Video] = []
    @Published var activeZone: InOutParameter?
    @Published var videoPlayer = AVPlayer(url: URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    init() {
        let _ = VideoManager()
        self.videoManager = VideoManager.shared!
        self.videos = self.videoManager.fetchVideos()
    }
    
    func playVideo() {
        self.videoPlayer.play()
    }
    
    func stopVideo() {
        self.videoPlayer.pause()
    }
    
    func chooseVideo(video:Video){
        self.chosenVideo = video
        self.inOutZones = video.inoutPoints
        self.inOutZones.sort(by: {$0.from < $1.to})
        self.activeZone = self.inOutZones.first
        self.videoPlayer = AVPlayer(url: URL(string: video.url)!)
        // seek the first zone and play it
        
        if let zone = self.activeZone{
            self.videoPlayer.seek(to: CMTime(seconds: zone.from * self.videoPlayer.currentItem!.asset.duration.seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) // Update location of the hand
            
            self.activeZone = zone
        }
    }
    
    func seekVideo(location: Double, secondScale: Double){
        // Now I have to determine the users touch and whether it is in the some inoutZone or not ofc if it does exists. If it doesnt just seek, if it does play the closest one.
        // And I have to implement looping mechanism in the active zone
        let tappedSecond = location / secondScale
        // Now lets check if the tapped second is in some zone if so lets set it if no save it as closest zone so far
        print(tappedSecond)
        if self.inOutZones.count > 0 {
            var closestZone = self.inOutZones.first!
            if let currentItem = self.videoPlayer.currentItem {
                for zone in self.inOutZones {
                    // Check if we are in the zone
                    if zone.from * currentItem.asset.duration.seconds <= tappedSecond && zone.to * currentItem.asset.duration.seconds >= tappedSecond {
                        // Set this as active zone and return
                        print("We are in this loop bruh")
                        let videoPosition = CMTime(seconds: location / secondScale, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                        self.videoPlayer.seek(to: videoPosition)
                        self.activeZone = zone
                        return
                    }
                    // If it was not in the zone, set this zone as closest zone if it is the closest one.
                    // Check the beggining and the end of the closest zone and the new zone, from both sides. if any of these two are closer to the tap set new this zone as closest
                    // At the end set the closest zone as current and seek to it
                    let distanceFromClosestZoneBeggining = closestZone.from * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromCurrentZoneBeggining = zone.from * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromCurrentZoneEnd = zone.to * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromClosestZoneEnd = closestZone.to * currentItem.asset.duration.seconds - tappedSecond
                    print("----BEGGINING-------")
                    print(distanceFromClosestZoneBeggining)
                    print(distanceFromClosestZoneEnd)
                    print(distanceFromCurrentZoneBeggining)
                    print(distanceFromCurrentZoneEnd)
                    print("-----------END------------")
                    if abs(distanceFromClosestZoneBeggining) > abs(distanceFromCurrentZoneBeggining) || abs(distanceFromClosestZoneEnd) > abs(distanceFromCurrentZoneEnd){
                        // Set this zone as closest one
                        
                        closestZone = zone
                    }
                }
                // Seek to the closest zone and set it as active zone
                let videoPosition = CMTime(seconds: closestZone.from * currentItem.asset.duration.seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                self.videoPlayer.seek(to: videoPosition)
                self.activeZone = closestZone
            }
            return
        }
        let videoPosition = CMTime(seconds: location / secondScale, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.videoPlayer.seek(to: videoPosition)
    }
}
