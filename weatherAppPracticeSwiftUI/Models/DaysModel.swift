//
//  DaysModel.swift
//  weatherAppPracticeSwiftUI
//
//  Created by Ahmed Hamza on 2/27/25.
//

import Foundation

//struct DayWeather: Identifiable{
//    var id = UUID() 
//    var dayOfWeek: String
//    var imageName: String
//    var temp: Int
//}

struct WeatherData: Decodable{
    var latitude: Double
    var longitude: Double
    var timezone: String
    var daily: Daily
}

struct Daily: Decodable {
    let time: [String]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min" 
    }
    
}


extension Double { // to round and convert to int
    func toInt() -> Int {
        return Int(self.rounded())
    }
}


extension String { // convert dates to Str
    func toDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}


struct City {
    let name: String
    let latitude: Double
    let longitude: Double
}
