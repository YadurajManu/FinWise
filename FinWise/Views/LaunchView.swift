//
//  LaunchView.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                // Logo
                Image("FinWise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color.finWiseDarkGreen)
                
                // App Name
                Text("FinWise")
                    .font(.poppins(size: 48, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.finWiseGreen)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LaunchView()
} 