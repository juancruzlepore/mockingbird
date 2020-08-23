//
//  ProgressBar.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import AppKit
import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    @Binding var referenceValue: Float
    @Binding var newValue: Float
    
    @State var hover: Bool = false
    
    let color: NSColor
    let darker: NSColor
    
//    init(value: Binding<Float>,
//         referenceValue: Binding<Float>,
//         color: NSColor,
//         darker: NSColor){
//        self._value = value
//        self._referenceValue = referenceValue
//        self.color = color
//        self.darker = darker
//    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                Rectangle().frame(width: min(CGFloat(self.referenceValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(self.darker))
//                    .animation(.linear)
                Rectangle().frame(width: min(CGFloat(self.newValue)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(self.color.brighter(amount: 0.7)))
//                .animation(.linear)
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(self.color))
//                    .animation(.linear)
            }.cornerRadius(45.0).onHover(perform: { _ in self.hover = true })
        }
    }
}

struct Tooltip: NSViewRepresentable {
    let tooltip: String

    func makeNSView(context: NSViewRepresentableContext<Tooltip>) -> NSView {
        let view = NSView()
        view.toolTip = tooltip
        return view
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<Tooltip>) {
        nsView.toolTip = tooltip
    }
}

struct ProgressBar_Previews: PreviewProvider {
    @State static var progressValue: Float = 0.3
    @State static var referenceValue: Float = 0.7
    @State static var newValue: Float = 0.7
    
    static let baseColor = NSColor.green
    
    static var previews: some View {
        ProgressBar(
            value: $progressValue,
            referenceValue: $referenceValue,
            newValue: $newValue,
            color: baseColor,
            darker: baseColor.darker()
        ).frame(maxWidth: 280).frame(height: 20)
    }
}
