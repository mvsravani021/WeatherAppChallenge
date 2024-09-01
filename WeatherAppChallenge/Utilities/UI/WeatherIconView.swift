//
//  WeatherIconView.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import SwiftUI

struct WeatherIconView: View {
    let icon: String
    
    var body: some View {
        VStack {
            if let weatherStatusImage = ImageFetcher.shared.image(for: icon) {
                weatherStatusImage
                    .resizable()
            } else {
                AsyncImage(url: iconURL) { image in
                    ImageFetcher.shared.addImageToCache(image, for: icon)
                        .resizable()
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .foregroundStyle(.white)
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
    }
    
    var iconURL: URL? {
        URL(string: Constants.iconURL + icon + "@2x.png")
    }
}

#Preview {
    VStack(spacing: 20) {
        WeatherIconView(icon: "02d")
        WeatherIconView(icon: "03d")
        WeatherIconView(icon: "01d")
        WeatherIconView(icon: "50n")
    }
    .background(.gray)
}
