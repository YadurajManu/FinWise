//
//  FontExtensions.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

extension Font {
    static func poppins(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Poppins", size: size).weight(weight)
    }
    
    static func leagueSpartan(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("League Spartan", size: size).weight(weight)
    }
}

extension Color {
    static let finWiseGreen = Color(red: 0, green: 0.82, blue: 0.62)
    static let finWiseDarkGreen = Color(red: 0.05, green: 0.24, blue: 0.24)
} 