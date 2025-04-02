//
//  WeatherViewModel.swift
//  weatherAppPracticeSwiftUI
//
//  Created by Ahmed Hamza on 3/6/25.
//

import Foundation
import Combine



enum WeatherViewState{
    case loading
    case loaded(WeatherData)
    case error(Error)
}

class WeatherViewModel: ObservableObject{
 
    @Published var weatherList: WeatherData?
    private var cancelable = Set<AnyCancellable>()
    
    var safeWeatherList: WeatherData {
            return weatherList ?? WeatherData(latitude: 0, longitude: 0, timezone: "", daily: Daily(time: [], temperatureMax: [], temperatureMin: []))
        }
    var apiManager: NetworkManagerProtocol
    init(apiManager: NetworkManagerProtocol) {
        self.apiManager = apiManager
        //getWeather()
    }
    
    
    func getWeather(latitude: Double, longitude: Double){
        let url = APIService.getUrl(latitude: latitude, longitude: longitude)
        self.apiManager.fetchData(from: url, modelType: WeatherData.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    print("Task is finished")
                case .failure(let error):
                    switch error{
                        
                    default:
                        print(error.localizedDescription)
                       // self.WeatherViewState = .error(error)

                    }
                }
            } receiveValue: { [weak self] weather in
                self?.weatherList = weather
                //self?.WeatherViewState = .loaded(weather)
            }
            .store(in: &cancelable)

    }
    
}
