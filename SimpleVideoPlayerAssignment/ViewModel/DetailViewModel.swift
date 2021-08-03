//
//  DetailViewModel.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import AVKit

final class DetailViewModel: ObservableObject {
    let videoManager: VideoManager
    @Published var inOutZones: [InOutParameter] = []
    @Published var chosenVideo: Video = Video(id: -1, name: "", url: "", inoutPoints: [])
    @Published var videos: [Video] = []
    @Published var activeZone: InOutParameter?
    @Published var inoutZonePositions: [CGPoint] = []
    @Published var videoPlayer = AVPlayer(url: URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
    init() {
        _ = VideoManager()
        self.videoManager = VideoManager.shared!
        self.videos = self.videoManager.fetchVideos()
    }

    /// Use this function to play the video
    func playVideo() {
        self.videoPlayer.play()
    }

    /// Use this function to pause the video
    func stopVideo() {
        self.videoPlayer.pause()
    }

    /// Use this function to select video to play and prepare videoplayer
    /// - Parameter video: chosen video
    func chooseVideo(video: Video, handler: @escaping () -> Void) {
        self.chosenVideo = video
        self.inOutZones = video.inoutPoints
        self.inOutZones.sort(by: {$0.from < $1.to})
        self.activeZone = self.inOutZones.first
        self.videoPlayer = AVPlayer(url: URL(string: video.url)!)
        // seek the first zone and play it

        // create fill position array
        inoutZonePositions = []
        for _ in self.inOutZones {
            inoutZonePositions.append(CGPoint(x: 0.0, y: 0.0))
        }
        if let zone = self.activeZone {
            self.videoPlayer.seek(to: CMTime(seconds: zone.from * self.videoPlayer.currentItem!.asset.duration.seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)

            self.activeZone = zone
        }
        self.playVideo()
        handler()
    }

    /// Use this function to calculate the on-screen scale
    /// One second is equivalent to what value on-screen so we can move thumb accordingly
    /// - Parameter totalTime: total length of the video
    /// - Parameter width: width of the screen
    /// - Returns: desired multiplication variable
    func calculateScale(totalTime: CMTime, width: CGFloat) -> Double {
        if (Double(width) / totalTime.seconds).isNaN {
            return 0.0
        }
        return Double(width) / totalTime.seconds
    }

    /// Use this function to calculate the on-screen position of inOutZone
    /// - Parameter scale: determines the multiplication variable, get it via calculateScale function
    /// - Parameter playFrom: from what point do we want to play the video i.e 0.2
    /// - Parameter playUntil: until what point do we want to play the video i.e 0.8
    /// - Parameter videoTotalTime: total length of the current video
    /// - Returns: position of the inOutZone as CGPoint
    func calculateInOutZonePosition(scale: Double, playFrom: Double, playUntil: Double, videoTotalTime: CMTime) -> CGPoint {
        var x = scale * playFrom * videoTotalTime.seconds
        var y = scale * playUntil * videoTotalTime.seconds
        if x.isNaN {
            x = 0.0
        }
        if y.isNaN {
            y = 0.0
        }
        return CGPoint(x: x, y: y)
    }

    /// Use this function to seek exact time in the video
    /// - Parameter location: location of the tap on the slider
    /// - Parameter secondScale: scale of the one second on the display, to get use calculateScale function
    func seekVideo(location: Double, secondScale: Double) {
        // Now I have to determine the users touch and whether it is in the some inoutZone or not ofc if it does exists. If it doesnt just seek, if it does play the closest one.
        let tappedSecond = location / secondScale
        // Now lets check if the tapped second is in some zone if so lets set it if no save it as closest zone so far
        if self.inOutZones.count > 0 {
            var closestZone = self.inOutZones.first!
            if let currentItem = self.videoPlayer.currentItem {
                for zone in self.inOutZones {
                    // Check if we are in the zone
                    if zone.from * currentItem.asset.duration.seconds <= tappedSecond && zone.to * currentItem.asset.duration.seconds >= tappedSecond {
                        // Set this as active zone and return
                        let videoPosition = CMTime(seconds: location / secondScale, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                        self.videoPlayer.seek(to: videoPosition, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                        self.activeZone = zone
                        return
                    }
                    // If it was not in the zone, set this zone as closest zone if it is the closest one.
                    // Check the beggining and the end of the closest zone and the new zone, from both sides. if any of these two are closer to the tap set this zone as closest
                    let distanceFromClosestZoneBeggining = closestZone.from * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromCurrentZoneBeggining = zone.from * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromCurrentZoneEnd = zone.to * currentItem.asset.duration.seconds - tappedSecond
                    let distanceFromClosestZoneEnd = closestZone.to * currentItem.asset.duration.seconds - tappedSecond
                    if abs(distanceFromClosestZoneBeggining) > abs(distanceFromCurrentZoneBeggining) || abs(distanceFromClosestZoneEnd) > abs(distanceFromCurrentZoneEnd) {
                        // Set this zone as closest one
                        closestZone = zone
                    }
                }
                // Seek to the closest zone and set it as active zone
                let videoPosition = CMTime(seconds: closestZone.from * currentItem.asset.duration.seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                self.videoPlayer.seek(to: videoPosition, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                self.activeZone = closestZone
            }
            return
        }
        // If there are no zones just seek and play
        let videoPosition = CMTime(seconds: location / secondScale, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.videoPlayer.seek(to: videoPosition, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}
