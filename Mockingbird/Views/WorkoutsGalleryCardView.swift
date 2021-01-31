//
//  WorkoutsGalleryCardView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 16/1/21.
//  Copyright © 2021 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct WorkoutsGalleryCardView: View {
    let workout: Workout
    
    var body: some View {
        VStack{
            Text(workout.name)
            Text(workout.mainMuscle.rawValue)
            Text(String(workout.dependencies.count))
        }
    }
}

struct WorkoutsGalleryCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsGalleryCardView(workout: WorkoutDefinitions.getById(ID: 1)!)
    }
}
