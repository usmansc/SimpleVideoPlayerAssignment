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
    @EnvironmentObject var menuViewModel: MenuViewModel

    var body: some View {
        VStack {
            VideoPlayerView(videoPlayer: self.$detailViewModel.videoPlayer)
            Text(self.detailViewModel.chosenVideo.name)
            HStack {
                Button(action: {
                    self.playing.toggle()
                    self.playing ? self.detailViewModel.videoPlayer.play() : self.detailViewModel.videoPlayer.pause()
                }) {
                    Image(systemName: playing ? "pause.fill" : "play.fill")
                }
            }

            Slider(videoPlayer: self.detailViewModel.videoPlayer, inOutZones: self.detailViewModel.chosenVideo.inoutPoints).environmentObject(detailViewModel)
        }
        .toolbar {
            Button(action: {
                self.menuViewModel.selectItem(which: self.menuViewModel.items[0])
            }) {
                self.menuViewModel.selected != 0 ? Text("Back") : Text("")
            }
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
