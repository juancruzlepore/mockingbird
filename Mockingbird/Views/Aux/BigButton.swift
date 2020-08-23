//
//  BigButton.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct BigButton: View {
    let buttonText: Text
    private let gray: Double = 65
    private let hoveredGray: Double = 69
    @State private var hovered = false
    
    
    var body: some View {
        buttonText.padding(.vertical, 25).padding(.horizontal, 50)
            .background(hovered
                ? Color.init(red: hoveredGray/255.0, green: hoveredGray/255.0, blue: hoveredGray/255.0)
            : Color.init(red: gray/255,
                         green: gray/255,
                         blue: gray/255))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .trim()
                    .stroke(
                        hovered
                            ? Color.init(red: 67/255, green: 181/255, blue: 247/255)
                            : Color.blue,
                        lineWidth: 2)
                    .onHover(perform: { isHovered in
                        self.hovered = isHovered
                    })
        )
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            BigButton(buttonText: Text("Test un poco largo"))
            BigButton(buttonText: Text("Test muy muy muy muy muy largo"))
            BigButton(buttonText: Text("Test"))
        }
        
    }
}
