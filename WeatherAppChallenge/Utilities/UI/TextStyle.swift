//
//  TextStyle.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/29/24.
//

import Foundation
import SwiftUI

enum TextStyle {
    case title
    case temperature
    case feelsLikeTemp
    case description
    case subTitle
    case error
    case dayTitle
    case details
}

struct ForecastTextStyle: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .details:
            content
                .font(.system(size: 18))
                .foregroundColor(.black)
        case .dayTitle:
            content
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
        case .title:
            content
                .font(.system(size: 45))
                .fontWeight(.medium)
                .foregroundColor(.white)
        case .subTitle:
            content
                .font(.system(size: 18))
                .fontWeight(.light)
                .foregroundColor(.white)
        case .feelsLikeTemp:
            content
                .font(.system(size: 24))
                .fontWeight(.regular)
                .foregroundColor(.white)
        case .temperature:
            content
                .font(.system(size: 66))
                .fontWeight(.regular)
                .foregroundColor(.white)
        case .description:
            content
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        case .error:
            content
                .font(.title3)
                .fontWeight(.regular)
                .foregroundColor(.red)
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(ForecastTextStyle(style: style))
    }
}
