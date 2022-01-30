//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by  Paul on 13.12.2021.
//

import Foundation

// модель для хранения данных json

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    // перерчисление для хранения ключей свойств
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
