//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by  Paul on 13.12.2021.
//

import Foundation
import CoreLocation

// модель для сетевых запросов
class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    // свойство, в которое будет передано замыкание с экземпляром распарсенной модели
    var onCompletion: ((CurrentWeather) -> Void)?

    // общий метод, которые принимает значения перечисления и переключает через switch ссылки для запросов
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric"
        }
        
        peroformRequest(withURLString: urlString)
    }
    
    // общий метод для запроса данных
    fileprivate func peroformRequest(withURLString urlString: String) {
        
        // создаем объект класса URL (опциональный), передаем в него адрес-строку
        guard let url = URL(string: urlString) else { return }
        
        // создаем URL-сессию, получаем, проверяем и передаем данные data в currentWeather
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                // передаем спарсенный экземпляр через замыкание
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }.resume()
    }
    
    // метод для парсинга JSON (раскладывает данные в соответствии с моделью)
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        
        // создаем декодер для декодирования данных
        let decoder = JSONDecoder()
        
        // передаем в декодер нашу модель (структуру), через блок do-catch
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
