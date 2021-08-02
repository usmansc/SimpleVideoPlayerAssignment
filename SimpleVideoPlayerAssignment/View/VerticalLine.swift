//
//  VerticalLine.swift
//  SimpleVideoPlayerAssignment
//
//  Created by Lukas Schmelcer on 02/08/2021.
//

import Foundation
import SwiftUI
import AVKit

struct VerticalLine: View {
    @Binding<CMTime> var videoPosition: CMTime
    @Binding<CGPoint> var location: CGPoint
    @Binding<Double> var secondScale: Double
    var geometry: GeometryProxy
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width/99.0, height: 40)
            .cornerRadius(3.0)
            .position(x: 1 + CGFloat((videoPosition.seconds * secondScale)), y: geometry.size.height/2)
    }
}
