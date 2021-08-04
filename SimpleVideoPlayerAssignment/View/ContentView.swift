//
//  ContentView.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 01/08/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var detailViewModel: DetailViewModel
    @EnvironmentObject var menuViewModel: MenuViewModel
    @State var selection: Int? =  -1
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if self.menuViewModel.selected == Menu.detail.rawValue {
                    DetailView().environmentObject(detailViewModel)

                } else {
                    List {
                        ForEach(detailViewModel.videos, id: \.self) { video in
                            Button(action: {
                                self.detailViewModel.chooseVideo(video: video) {
                                    self.menuViewModel.selectItem(which: self.menuViewModel.items[1])
                                }

                            }) {
                                Text(video.name).foregroundColor(Color.black)
                            }
                    }
                    }
                }

            }

        }
    }
}
