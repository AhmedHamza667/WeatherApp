//
//  ContentView.swift
//  weatherAppPracticeSwiftUI
//
//  Created by Ahmed Hamza on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherVM = WeatherViewModel(apiManager: NetworkManager())
    @State private var isNight = false
    @StateObject var locationManager = LocationManager()
    @State private var selectedCity = "Atlanta"

    
    // predefined cities
    let cities: [City] = [
        City(name: "Atlanta", latitude: 33.800235, longitude: -84.407171),
        City(name: "New York", latitude: 40.712776, longitude: -74.005974),
        City(name: "Los Angeles", latitude: 34.052235, longitude: -118.243683),
        City(name: "Chicago", latitude: 41.878113, longitude: -87.629799),
        City(name: "Miami", latitude: 25.761681, longitude: -80.191788)
    ]
    
    var body: some View {
        NavigationStack{
            ZStack {
                BackGroundView(isNight: $isNight)
                VStack {
                    Menu {
                        Picker(selection: $selectedCity, label: EmptyView()) {
                            ForEach(cities, id: \.name) { city in
                                Text(city.name)
                                    .tag(city.name)
                            }
                        }
                    } label: {
                        Text(selectedCity)
                            .font(.system(size: 32, weight: .medium, design: .default))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    
                    MainWeatherView(
                        isNight: $isNight,
                        temp: weatherVM.weatherList?.daily.temperatureMax[0].toInt() ?? 00
                    )
                    if let weatherData = weatherVM.weatherList {
                        WeeklyWeather(weekData: weatherData)
                    } else {
                        Text("Loading...")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                    Spacer()
                    Button {
                        isNight.toggle()
                    } label: {
                        WeatherButton(text: "Change Day Time", textColor: .blue, backGroundColor: .white)
                    }
                    NavigationLink {
                        MapView()
                    } label: {
                        Text("Map")
                            .frame(width: 280, height:50)
                            .background(.white)
                            .foregroundStyle(.blue)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear{
            let defaultCity = cities.first(where: { $0.name == selectedCity })!
            weatherVM.getWeather(latitude: defaultCity.latitude, longitude: defaultCity.longitude)

        }
//        .onReceive(weatherVM.$weatherList) { weather in
//            print(weather)
//
//        }
        
//        .onReceive(locationManager.$currentLocation) { newLocation in
//                    if let location = newLocation {
//                        weatherVM.getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                        print("Location Updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//                    }
//                }
        
        .onChange(of: selectedCity) { newCity in
                   if let city = cities.first(where: { $0.name == newCity }) {
                       locationManager.updateLocation(latitude: city.latitude, longitude: city.longitude)
                       print("📍 Updated Location to: \(city.name) - \(city.latitude), \(city.longitude)")
                   }
               }
               .onReceive(locationManager.$currentLocation) { newLocation in
                   if let location = newLocation {
                       weatherVM.getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                       print("🌍 Location Updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                   }
               }
        
    }
}

#Preview {
    ContentView()
}



struct BackGroundView: View {
    @Binding var isNight: Bool
    var body: some View {
        LinearGradient(
            colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View{
    var cityName: String
    var body: some View{
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct MainWeatherView: View {
    @Binding var isNight: Bool
    var temp: Int
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isNight ? "moon.stars.fill" : "cloud.sun.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
            Text("\(temp)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 40)    }
}


struct WeatherButton: View {
    var text: String
    var textColor: Color
    var backGroundColor: Color
    var body: some View {
        Text(text)
            .frame(width: 280, height:50)
            .background(backGroundColor)
            .foregroundStyle(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}



struct WeeklyWeather: View {
    var weekData: WeatherData
    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<5, id: \.self) { i in
                WeatherDayView(
                    dayOfWeek: weekData.daily.time[i].toDayOfWeek(),
                    temp: weekData.daily.temperatureMax[i].toInt()
                )
            }
        }
    }
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var temp: Int
    
    func getWeatherImage(for temperature: Int) -> String {
        switch temperature {
        case let temp where temp >= 80:
            return "sun.max.fill" // Hot weather
        case let temp where temp >= 60:
            return "cloud.sun.fill" // Mild weather
        case let temp where temp >= 40:
            return "cloud.fill" // Cool weather
        default:
            return "snow" // Cold weather
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text(dayOfWeek)
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            Image(systemName: getWeatherImage(for: temp))
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("\(temp)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}
