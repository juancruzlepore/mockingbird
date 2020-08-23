//
//  BigButton.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct SmallButton: View {
    let buttonText: Text
    private let gray: Double = 65
    private let hoveredGray: Double = 69
    private let disabledGray: Double = 100
    
    private var hoveredBackground: Color {
        grayFromDouble(value: hoveredGray)
    }
    
    private var normalBackground: Color {
        grayFromDouble(value: gray)
    }
    
    private var disabledBackground: Color {
        grayFromDouble(value: disabledGray)
    }
    
    private var normalBorder: Color {
        Color.blue
    }
    
    private var hoveredBorder: Color {
        Color.init(red: 67/255, green: 181/255, blue: 247/255)
    }
    
    private func grayFromDouble(value: Double) -> Color {
        return Color.init(red: value/255,
                          green: value/255,
                          blue: value/255)
    }
    
    @State private var hovered = false
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        buttonText.foregroundColor(isEnabled ? Color.white : normalBackground)
            .padding(.vertical, 5).padding(.horizontal, 10)
            .background(isEnabled ? (hovered
                ? hoveredBackground
                : normalBackground) : disabledBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .trim()
                    .stroke(
                        isEnabled ?
                            (hovered
                                ? hoveredBorder
                                : normalBorder) : disabledBackground,
                        lineWidth: 2)
                    .onHover(perform: { isHovered in
                        self.hovered = isHovered
                    })
        )
    }
}

struct SmallButtonWithImage: View {
    var image: Image
    var forceDisabledStyle: Bool = false
    
    private var showEnabledStyle: Bool {
        self.isEnabled && !self.forceDisabledStyle
    }
    
    private let gray: Double = 65
    private let hoveredGray: Double = 69
    private let disabledGray: Double = 100
    
    private var hoveredBackground: Color {
        grayFromDouble(value: hoveredGray)
    }
    
    private var normalBackground: Color {
        grayFromDouble(value: gray)
    }
    
    private var disabledBackground: Color {
        grayFromDouble(value: disabledGray)
    }
    
    private var normalBorder: Color {
        Color.blue
    }
    
    private var hoveredBorder: Color {
        Color.init(red: 67/255, green: 181/255, blue: 247/255)
    }
    
    private func grayFromDouble(value: Double) -> Color {
        return Color.init(red: value/255,
                          green: value/255,
                          blue: value/255)
    }
    
    @State private var hovered = false
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        image.resizable().foregroundColor(
            showEnabledStyle ? Color.white : normalBackground)
            .padding(.vertical, 5).padding(.horizontal, 10)
            .background(showEnabledStyle ? (hovered
                ? hoveredBackground
                : normalBackground) : disabledBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .trim()
                    .stroke(
                        !hovered ?
                            ( showEnabledStyle
                                ? normalBorder
                                : disabledBackground)
                        : hoveredBorder
                        ,
                        lineWidth: 2)
                    .onHover(perform: { isHovered in
                        self.hovered = isHovered
                    })
        ).frame(width: 50, height: 40)
    }
}

struct SmallButton_Previews: PreviewProvider {
    static let iconSize: CGFloat = 25
    
    static var previews: some View {
        VStack{
            SmallButton(buttonText: Text("Test un poco largo"))
            SmallButton(buttonText: Text("Test muy muy muy muy muy largo"))
            SmallButton(buttonText: Text("Test")).disabled(true)
            SmallButtonWithImage(image: Utils.getImageForMuscle(muscle: .BACK))
            SmallButtonWithImage(image: Utils.getImageForMuscle(muscle: .ABS))
            SmallButtonWithImage(image: Utils.getImageForMuscle(muscle: .ARMS))
        }
    }
}
