//
//  Slider.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import SwiftUI
import AVKit

struct Slider: View {
    @State var videoPosition: CMTime = CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    @State var location: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State var inOutZonePoisition: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State var updateLocation: Bool = false
    @State var secondScale: Double = 0.0
    @EnvironmentObject var detailViewModel: DetailViewModel
    var videoPlayer: AVPlayer
    var inOutZones: [InOutParameter]

    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width/1.05, height: 50)
                    .foregroundColor(.black)
                    .background(Color.black)
                    .cornerRadius(25.0)
                    .padding()
                ForEach(self.detailViewModel.chosenVideo.inoutPoints, id: \.self) { zone in

                    InOutZone(geometry: geometry, position: self.detailViewModel.calculateInOutZonePosition(scale: self.secondScale, playFrom: zone.from, playUntil: zone.to, videoTotalTime: self.detailViewModel.videoPlayer.currentItem!.duration), zone: zone).onAppear(perform: {
                    })
                }

                VerticalLine(videoPosition: $videoPosition, location: $location, secondScale: $secondScale, geometry: geometry)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            if updateLocation {
                                self.location = value.location
                                self.detailViewModel.seekVideo(location: Double(self.location.x), secondScale: self.secondScale)
                                self.updateLocation = false
                            }

                        })
                        .onEnded({ _ in
                            self.updateLocation = true
                        })
            )
            .onAppear(perform: {
                let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                self.secondScale = self.detailViewModel.calculateScale(totalTime: self.detailViewModel.videoPlayer.currentItem!.duration, width: geometry.size.width)
                self.inOutZonePoisition = self.detailViewModel.calculateInOutZonePosition(scale: self.secondScale, playFrom: inOutZones.first?.from ?? 0.0, playUntil: inOutZones.first?.to ?? 0.0, videoTotalTime: self.detailViewModel.videoPlayer.currentItem!.duration)
                _ = self.detailViewModel.videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) {
                    time in
                    // Check if the video is out of the activeZone, if so loop back to the beggining
                    self.videoPosition = time

                    if let currentItem = self.detailViewModel.videoPlayer.currentItem {
                        if currentItem.currentTime().seconds >= currentItem.asset.duration.seconds * (self.detailViewModel.activeZone?.to ?? 1.0) {
                            // loop the video to the beggining and set the videoPosition to that time // We can do this with AVLooper but I am not sure if this is allowed because we are supposed to use AVPlayer...
                            let newTime = CMTime(seconds: currentItem.asset.duration.seconds * (self.detailViewModel.activeZone?.from ?? 0.0), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                            self.detailViewModel.videoPlayer.seek(to: newTime)
                            self.videoPosition = newTime
                            self.detailViewModel.playVideo()
                        }
                    }

                }

            })
        }).frame(width: UIScreen.main.bounds.width/1.05, height: 50)
        .foregroundColor(.black)
        .background(Color.black)
        .cornerRadius(25.0)
        .padding()

    }
}
