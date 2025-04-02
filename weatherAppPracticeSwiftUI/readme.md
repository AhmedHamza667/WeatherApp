
# Weather App SwiftUI

A modern iOS weather application built with SwiftUI that provides weather forecasts for multiple cities with a clean, intuitive interface and interactive features.

## Features

- 🌤️ **5-Day Weather Forecast**: View temperature forecasts for the next 5 days
- 🌍 **Multiple Cities**: Choose from predefined major cities including:
  - Atlanta
  - New York
  - Los Angeles
  - Chicago
  - Miami
- 🗺️ **Interactive Map**: View your selected location on an interactive map
- 🌙 **Day/Night Mode**: Toggle between day and night themes
- 📍 **Location Services**: Uses device location for accurate weather data
- 🌡️ **Temperature Units**: Displays temperatures in Fahrenheit
- ⚡ **Real-time Updates**: Weather data updates automatically when changing cities

## Technical Details

- Built with SwiftUI and follows MVVM architecture
- Uses Open-Meteo API for weather data
- Implements CoreLocation for location services
- MapKit integration for location visualization
- Combines framework for reactive programming
- Clean architecture with separate Models, Views, and ViewModels

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `weatherAppPracticeSwiftUI.xcodeproj` in Xcode
3. Build and run the project

## Usage

1. Launch the app
2. Select a city from the dropdown menu or use your current location
3. View the current temperature and 5-day forecast
4. Toggle between day and night modes using the button
5. Access the map view to see your selected location

## Privacy

The app requires location permissions to:
- Access your current location for local weather data
- Display your location on the map

## Credits

- Weather data provided by [Open-Meteo API](https://api.open-meteo.com)
- Built by Ahmed Hamza

## License

This project is available for personal use and learning purposes.
