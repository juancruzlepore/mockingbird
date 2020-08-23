//
//  SelectMuscleBar.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 16/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct SelectMuscleBar: View {
    @Binding var selectedMuscles: [MuscleGroup]
    
    var body: some View {
        HStack {
            ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                SmallButtonWithImage(
                    image: Utils.getImageForMuscle(muscle: muscle),
                    forceDisabledStyle: !self.selectedMuscles.contains(muscle))
                    .onTapGesture {
                        self.toggleMuscle(muscle: muscle)
                }
            }
        }.padding(.all, 10)
    }
    
    func toggleMuscle(muscle: MuscleGroup){
        if(self.selectedMuscles.contains(muscle)){
            selectedMuscles.removeAll(where: {$0 == muscle})
        } else {
            selectedMuscles.append(muscle)
        }
    }
}

struct SelectMuscleBar_Previews: PreviewProvider {
    @State static var selectedMuscles: [MuscleGroup] = []
    
    static var previews: some View {
        SelectMuscleBar(selectedMuscles: Self.$selectedMuscles)
    }
}
