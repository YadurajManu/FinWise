//
//  LaunchViewModel.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import SwiftUI

class LaunchViewModel: ObservableObject {
    @Published var isLaunchFinished = false
    
    init() {
        // Simulate launch delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isLaunchFinished = true
            }
        }
    }
} 