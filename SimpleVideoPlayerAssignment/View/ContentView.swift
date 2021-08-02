//
//  ContentView.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var detailViewModel: DetailViewModel
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(detailViewModel.videos, id: \.self) { video in
                        NavigationLink(video.name, destination: DetailView().environmentObject(detailViewModel))
                            .gesture(TapGesture().onEnded({ _ in
                                self.detailViewModel.chooseVideo(video: video)
                            }))
                    }
                }
            }
        }
    }
}
