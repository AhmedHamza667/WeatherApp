//
//  weatherAppPracticeSwiftUITests.swift
//  weatherAppPracticeSwiftUITests
//
//  Created by Ahmed Hamza on 2/25/25.
//

import XCTest
@testable import weatherAppPracticeSwiftUI
import Combine

final class weatherAppPracticeSwiftUITests: XCTestCase {
    
    var weatherViewModel: WeatherViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        weatherViewModel = WeatherViewModel(apiManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        weatherViewModel = nil
        mockNetworkManager = nil
        cancellables = nil
    }
    
    // Test weather data parsing
    func testWeatherDataParsing() throws {
        // Given
        let expectation = expectation(description: "Weather data loaded")
        let mockWeatherData = WeatherData(
            latitude: 33.800235,
            longitude: -84.407171,
            timezone: "America/New_York",
            daily: Daily(
                time: ["2024-03-10", "2024-03-11", "2024-03-12"],
                temperatureMax: [75.0, 78.0, 82.0],
                temperatureMin: [65.0, 68.0, 70.0]
            )
        )
        
        // When
        mockNetworkManager.mockWeatherData = mockWeatherData
        
        // publisher to monitor changes
        weatherViewModel.$weatherList
            .dropFirst() 
            .sink { weather in
                if weather != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        weatherViewModel.getWeather(latitude: 33.800235, longitude: -84.407171)
        
        // Wait for the async operation to complete
        wait(for: [expectation], timeout: 5.0)
        
        // Then
        XCTAssertNotNil(weatherViewModel.weatherList)
        XCTAssertEqual(weatherViewModel.weatherList?.latitude, 33.800235)
        XCTAssertEqual(weatherViewModel.weatherList?.longitude, -84.407171)
        XCTAssertEqual(weatherViewModel.weatherList?.timezone, "America/New_York")
        XCTAssertEqual(weatherViewModel.weatherList?.daily.temperatureMax.count, 3)
    }
    
    // Test temperature conversion
    func testTemperatureConversion() {
        // Given
        let temperature = 75.5
        
        // When
        let convertedTemp = temperature.toInt()
        
        // Then
        XCTAssertEqual(convertedTemp, 76)
    }
    
    // Test date string conversion to day of week
    func testDateStringToDayOfWeek() {
        // Given
        let dateString = "2024-03-10"
        
        // When
        let dayOfWeek = dateString.toDayOfWeek()
        
        // Then
        XCTAssertEqual(dayOfWeek, "Sun")
    }
    
    // Test city model
    func testCityModel() {
        // Given
        let city = City(name: "Atlanta", latitude: 33.800235, longitude: -84.407171)
        
        // Then
        XCTAssertEqual(city.name, "Atlanta")
        XCTAssertEqual(city.latitude, 33.800235)
        XCTAssertEqual(city.longitude, -84.407171)
    }
    
    // Test weather day view image selection
    func testWeatherDayViewImageSelection() {
        // Given
        let weatherDayView = WeatherDayView(dayOfWeek: "Mon", temp: 85)
        
        // When
        let imageName = weatherDayView.getWeatherImage(for: 85)
        
        // Then
        XCTAssertEqual(imageName, "sun.max.fill")
    }
}

// Mock Network Manager for testing
class MockNetworkManager: NetworkManagerProtocol {
    var mockWeatherData: WeatherData?
    var shouldSucceed = true
    
    func fetchData<T: Decodable>(from url: String, modelType: T.Type) -> AnyPublisher<T, Error> {
        if shouldSucceed, let mockData = mockWeatherData as? T {
            return Just(mockData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIErrors.noDataError)
                .eraseToAnyPublisher()
        }
    }
}
