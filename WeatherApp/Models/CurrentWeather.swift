//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by  Paul on 14.12.2021.
//

import Foundation

// модель для передачи данных в интерфейс
struct CurrentWeather {
    
    let cityName: String
    
    // свойство температуры и вычисляемые свойства, возвращающие строки с округленными числами
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    // свойство для назначения системных картинок иконке погоды
    var conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    // инициализатор, который берет данные, полученные в сетевую модель
    // если данные будут отсутствовать, вернет nil
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
    
}
