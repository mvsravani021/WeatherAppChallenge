//
//  SearchResultModel.swift
//  WeatherAppChallenge
//
//  Created by Venkata Sravani Motamarri on 8/30/24.
//

import Foundation

struct SearchModel: Decodable {
    let name: String
    let state: String?
    let country: String
    let lat: Double
    let lon: Double
}


struct SearchResult: Identifiable, Hashable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.lat == rhs.lat && lhs.long == rhs.long
    }
    
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(lat)
        hasher.combine(long)
    }
    
    var id: Self { self }
    
    let dataModel: SearchModel
    init(_ dataModel: SearchModel) {
        self.dataModel = dataModel
    }
    
    var name: String {
        dataModel.name
    }
    
    var state: String {
        var stateInfo = dataModel.state ?? ""
        stateInfo += (stateInfo != "" ? "," : "")
        return stateInfo + dataModel.country
    }
    
    var lat: Double {
        dataModel.lat
    }
    
    var long: Double {
        dataModel.lon
    }
    
}
