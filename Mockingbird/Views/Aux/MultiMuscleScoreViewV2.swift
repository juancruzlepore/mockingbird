//
//  MultiMuscleScoreViewV2.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 13/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct MultiMuscleScoreViewV2: View {
    
    @ObservedObject var provider: ScoresProvider
    
    var maxScore: Float {provider.maxScore}
    var scores: [MuscleGroup:Float] {provider.scores}
    var newScores: [MuscleGroup:Float]? {provider.newScores}
    var references: [MuscleGroup:Float]? {provider.references}
    var sortedScores: [(MuscleGroup, Float, Float, Float, String)] {
        var auxScores = scores
        references?.keys.forEach({
            if(auxScores[$0] == nil){
                auxScores[$0] = 0
            }
        })
        newScores?.keys.forEach({
            if(auxScores[$0] == nil){
                auxScores[$0] = 0
            }
        })
        return auxScores
            .sorted(by: { $0.key.rawValue < $1.key.rawValue })
            .map({($0.0,
                   $0.1,
                   references?[$0.0] ?? $0.1,
                   newScores?[$0.0] ?? $0.1,
                   "\($0.0.rawValue)-\($0.1)-\(references?[$0.0] ?? $0.1)-\(newScores?[$0.0] ?? $0.1)")})
    }
    
    var body: some View {
        VStack {
            ForEach(sortedScores, id: (\.4)) { muscle, score, reference, newScore, _ in
                MuscleScoreView(muscle: muscle,
                               score: score,
                               newScore: newScore,
                               reference: reference,
                               maxScore: self.maxScore)
            }
        }
    }
}

struct MultiMuscleScoreViewV2_Previews: PreviewProvider {
    @State static var scores: [MuscleGroup:Float] = [
            .ABS: 6,
            .ARMS: 3,
            .CHEST: 4
    ]
    
    @State static var newScores: [MuscleGroup:Float] = [
            .ABS: 6,
            .ARMS: 5,
            .CHEST: 4.5
    ]
    
    
    @State static var references: [MuscleGroup:Float] = [
            .ABS: 7,
            .ARMS: 6
    ]
    
    static var previews: some View {
        MultiMuscleScoreViewV2(provider: NewSeriesScoresProvider())
    }
}
