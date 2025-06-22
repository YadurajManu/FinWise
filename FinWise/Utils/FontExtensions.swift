//
//  FontExtensions.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

extension Font {
    static func poppins(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Poppins-Light", size: size)
        case .regular:
            return .custom("Poppins-Regular", size: size)
        case .medium:
            return .custom("Poppins-Medium", size: size)
        case .semibold:
            return .custom("Poppins-SemiBold", size: size)
        case .bold:
            return .custom("Poppins-Bold", size: size)
        default:
            return .custom("Poppins-Regular", size: size)
        }
    }
    
    static func leagueSpartan(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("LeagueSpartan-Light", size: size)
        case .regular:
            return .custom("LeagueSpartan-Regular", size: size)
        case .medium:
            return .custom("LeagueSpartan-Medium", size: size)
        case .semibold:
            return .custom("LeagueSpartan-SemiBold", size: size)
        case .bold:
            return .custom("LeagueSpartan-Bold", size: size)
        default:
            return .custom("LeagueSpartan-Regular", size: size)
        }
    }
}

extension Color {
    static let finWiseGreen = Color(red: 0/255, green: 208/255, blue: 158/255)
    static let finWiseDarkGreen = Color(red: 5/255, green: 24/255, blue: 24/255)
    static let finWiseLightGreen = Color(red: 135/255, green: 247/255, blue: 217/255)
    static let finWiseBackground = Color(red: 248/255, green: 248/255, blue: 248/255)
} 