//
//  BackgroundView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/28/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.green, .yellow]), startPoint: .top, endPoint: .bottom
                ))
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
