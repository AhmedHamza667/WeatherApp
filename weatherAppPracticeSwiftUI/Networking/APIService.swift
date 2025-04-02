//
//  APIService.swift
//  weatherAppPracticeSwiftUI
//
//  Created by Ahmed Hamza on 2/28/25.
//

import Foundation


struct APIService {

    static func getUrl(latitude: Double, longitude: Double) -> String {
        return "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&timezone=auto"
    }
}
