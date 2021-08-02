//
//  InOutZone.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import SwiftUI

struct InOutZone: View {
    @EnvironmentObject var detailViewModel: DetailViewModel
    @State var active: Bool = false
    var geometry: GeometryProxy
    var position: CGPoint
    var zone: InOutParameter
    var body: some View {
        Rectangle()
            .fill(active ? Color.green : Color.gray)
            .frame(width: position.y - position.x, height: 40, alignment: .bottomLeading)

            .position(x: position.x + (position.y - position.x) / 2, y: geometry.size.height/2)
            .onChange(of: self.detailViewModel.activeZone, perform: { _ in
                self.active = isActiveInOutZone()
            })
            .onAppear(perform: {
                self.active = isActiveInOutZone()
            })
    }

    /// Use this function to determine if the current zone is active zone
    /// - Returns: true if the active zone is the same as the current zone , false if the active zone is not the same as the current zone
    func isActiveInOutZone() -> Bool {
        if let activeZone = self.detailViewModel.activeZone {
            if activeZone == zone {
                return true
            }
        }
        return false
    }

}
