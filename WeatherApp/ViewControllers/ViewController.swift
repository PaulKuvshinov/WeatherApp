//
//  ViewController.swift
//  WeatherApp
//
//  Created by  Paul on 13.12.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIconImage: UIImageView!
    @IBOutlet var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    // создаем экземпляр структуры для использования в контроллере
    var networkWeatherManager = NetworkWeatherManager()
    
    // создаем экземпляр менеджера CLLocation через замыкание
    // lazy - чтобы не держать в памяти, если пользователь запретит использование гео-данных
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        // свойство для определения точности позиции
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        // метод для запроса у пользователя разрешения на доступ к гео-данным
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // обращаемся к замыканию через метод updateInterfaceWith
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        // если настройки гео-позиции включены, то делаем запрос
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        // помещаем вызов метода обновления интерфейса в главную очередь
        // вызываем главную очередь и выполняем код асинхронно
        DispatchQueue.main.async {
        self.cityLabel.text = weather.cityName
        self.temperatureLabel.text = weather.temperatureString
        self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
        self.weatherIconImage.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// подписываем ViewController на делегат CLLocation
extension ViewController: CLLocationManagerDelegate {
    
    // метод для получения текущих координат долготы и широты
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    // обязательный метод на случай ошибки
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

