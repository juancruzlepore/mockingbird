//
//  RoundedCorner.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 16/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - br, y: 0))
        path.addArc(center: CGPoint(x: w - br, y: br), radius: br,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - tr))
        path.addArc(center: CGPoint(x: w - tr, y: h - tr), radius: tr,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: tl, y: h))
        path.addArc(center: CGPoint(x: tl, y: h - tl), radius: tl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: bl))
        path.addArc(center: CGPoint(x: bl, y: bl), radius: bl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}


extension View {
    func customCornerRadius(tl: CGFloat = 0.0, tr: CGFloat = 0.0, bl: CGFloat = 0.0, br: CGFloat = 0.0) -> some View {
        clipShape(RoundedCorners(tl: tl, tr: tr, bl: bl, br: br))
    }
}
