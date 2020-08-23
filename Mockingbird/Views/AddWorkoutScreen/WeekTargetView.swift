//
//  WeekTargetView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 12/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct WeekTargetView: View {
    
    @EnvironmentObject var streaks: StreaksManager
    
    var body: some View {
        MultiMuscleScoreViewV2(provider: NewSeriesScoresProvider())
    }
}

struct WeekTargetView_Previews: PreviewProvider {
    static var previews: some View {
        WeekTargetView()
    }
}
