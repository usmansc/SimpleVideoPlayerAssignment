//
//  DetailView.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import SwiftUI
import AVKit

struct DetailView: View {
    
    var timeObserverToken: Any?
    @State var playing: Bool = true
    @EnvironmentObject var detailViewModel: DetailViewModel
    
    
    var body: some View {
        VStack{
            VideoPlayerView(videoPlayer: self.$detailViewModel.videoPlayer)
            Text(self.detailViewModel.chosenVideo.name)
            HStack{
                Button(action:{
                    self.playing.toggle()
                    self.playing ? self.detailViewModel.videoPlayer.play() : self.detailViewModel.videoPlayer.pause()
                }){
                    Image(systemName: playing ? "pause.fill" : "play.fill")
                }
            }
            
            Slider(videoPlayer: self.detailViewModel.videoPlayer,inOutZones: self.detailViewModel.chosenVideo.inoutPoints).environmentObject(detailViewModel)
        }
        .padding()
        .onAppear(perform: {
            self.detailViewModel.playVideo()
        })
        .onDisappear(perform: {
            self.detailViewModel.stopVideo()
        })
        
        
    }
}


// TODO: Now I need to stretch the inout zone
struct Slider: View {
    @State var videoPosition: CMTime = CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    @State var location: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State var inOutZonePoisition: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State var updateLocation: Bool = false
    @State var secondScale: Double = 0.0
    @EnvironmentObject var detailViewModel: DetailViewModel
    var videoPlayer: AVPlayer
    var inOutZones: [InOutParameter]
    
    var body: some View{
        GeometryReader(content: { geometry in
            ZStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width/1.05, height: 50)
                    .foregroundColor(.black)
                    .background(Color.black)
                    .cornerRadius(25.0)
                    .padding()
                ForEach(self.detailViewModel.chosenVideo.inoutPoints, id:\.self) { zone in
                    
                    InOutZone(geometry: geometry, position: calculateInOutZonePosition(scale: self.secondScale, playFrom: zone.from, playUntil: zone.to, videoTotalTime: self.detailViewModel.videoPlayer.currentItem!.duration),zone:zone).onAppear(perform:{
                    })
                }
                
                VerticalLine(videoPosition: $videoPosition, location: $location,secondScale: $secondScale, geometry:geometry)
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            if updateLocation{
                                // TODO: Maybe let user to use it as scrollable thumb
                                self.location = value.location
                                print("Should update location")
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
                self.secondScale = calculateScale(totalTime: self.detailViewModel.videoPlayer.currentItem!.duration,width: geometry.size.width)
                self.inOutZonePoisition = calculateInOutZonePosition(scale: self.secondScale, playFrom: inOutZones.first?.from ?? 0.0, playUntil: inOutZones.first?.to ?? 0.0, videoTotalTime: self.detailViewModel.videoPlayer.currentItem!.duration)
                _ = self.detailViewModel.videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: .main) {
                    time in
                    // Check if the video is out of the activeZone, if so loop back to the beggining
                    self.videoPosition = time
                    
                    if let currentItem = self.detailViewModel.videoPlayer.currentItem {
                        if currentItem.currentTime().seconds > currentItem.asset.duration.seconds * (self.detailViewModel.activeZone?.to ?? 1.0) {
                            // loop the video to the beggining and set the videoPosition to that time // We can do this with AVLooper but I am not sure if this is allowed because we are supposed to use AVPlayer...
                            let newTime = CMTime(seconds: currentItem.asset.duration.seconds * (self.detailViewModel.activeZone?.from ?? 1.0), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                            self.detailViewModel.videoPlayer.seek(to: newTime)
                            self.videoPosition = newTime
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
    
    func calculateScale(totalTime: CMTime,width: CGFloat) -> Double{
        if (Double(width) / totalTime.seconds).isNaN {
            return 0.0
        }
        return Double(width) / totalTime.seconds
        
    }
    
    func calculateInOutZonePosition(scale: Double, playFrom: Double, playUntil: Double, videoTotalTime: CMTime) -> CGPoint {
        var x = scale * playFrom * videoTotalTime.seconds
        var y = scale * playUntil * videoTotalTime.seconds
        if x.isNaN{
            x = 0.0
        }
        if y.isNaN{
            y = 0.0
        }
        return CGPoint(x: x, y: y)
    }
}

struct VerticalLine:View {
    @Binding<CMTime> var videoPosition: CMTime
    @Binding<CGPoint> var location: CGPoint
    @Binding<Double> var secondScale: Double
    var geometry: GeometryProxy
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width/99.0, height: 40)
            .cornerRadius(3.0)
            .position(x:1 + CGFloat((videoPosition.seconds * secondScale)),y:geometry.size.height/2)
    }
}

struct InOutZone: View{
    @EnvironmentObject var detailViewModel : DetailViewModel
    @State var active: Bool = false
    var geometry: GeometryProxy
    var position: CGPoint
    var zone: InOutParameter
    var body: some View{
        Rectangle()
            .fill(active ? Color.green : Color.gray)
            .frame(width: position.y - position.x, height: 40, alignment: .bottomLeading)
            
            .position(x:position.x + (position.y - position.x) / 2 ,y:geometry.size.height/2)
            .onChange(of: self.detailViewModel.activeZone, perform: { value in
                self.active = isActiveInOutZone()
            })
            .onAppear(perform: {
                self.active = isActiveInOutZone()
            })
        
    }
    
    func isActiveInOutZone() -> Bool {
        if let activeZone = self.detailViewModel.activeZone {
            if activeZone == zone{
                return true
            }
        }
        return false
        
    }
    
    
}
