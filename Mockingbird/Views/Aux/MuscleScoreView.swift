//
//  MucleScoreView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct MuscleScoreView: View {
    
    let muscle: MuscleGroup
    var score: Float {
        didSet {
            ratio = score / maxScore
        }
    }
    var newScore: Float {
        didSet {
            newScoreRatio = newScore / maxScore
        }
    }
    var reference: Float {
        didSet {
            referenceRatio = reference / maxScore
        }
    }
    
    let maxScore: Float
    @State var ratio: Float = 0.0
    @State var referenceRatio: Float = 0.0
    @State var newScoreRatio: Float = 0.0
    
    let height: CGFloat = 10
    let iconSize: CGFloat = 25
    
    var body: some View {
        HStack{
            Utils.getImageForMuscle(muscle: self.muscle)
                .resizable()
                .frame(height: self.iconSize).frame(width: iconSize)
            ProgressBar(
                value: self.$ratio,
                referenceValue: self.$referenceRatio,
                newValue: self.$newScoreRatio,
                color: self.color,
                darker: self.color.darker())
                .frame(height: self.height)
        }.onAppear {
            self.ratio = self.score / self.maxScore
            self.referenceRatio = self.reference / self.maxScore
            self.newScoreRatio = self.newScore / self.maxScore
        }
    }
    
    var color: NSColor {
        Utils.getColorForMuscle(muscle: self.muscle)
    }
}

struct MucleScoreView_Previews: PreviewProvider {
    static var previews: some View {
        MuscleScoreView(muscle: .ABS,
                       score: 5,
                       newScore: 5.5,
                       reference: 6,
                       maxScore: 7)
    }
}
