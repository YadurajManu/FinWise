//
//  OnboardingViewModel.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var showOnboarding = false
    @Published var showAuthentication = false
    
    func completeOnboarding() {
        showAuthentication = true
    }
} 