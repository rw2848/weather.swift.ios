//
//  WeatherDetailViewController.swift
//  hw2-datadisplayintable
//
//  Created by Runwei Wang on 9/27/23.
//

import UIKit

class WeatherDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var weather: CityWeather?
    var backgroundImageView: UIImageView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.threeDayForecast.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Forecast", for: indexPath) as! ForecastCell
        cell.backgroundColor = UIColor.clear
        
        guard let forecast = weather?.threeDayForecast[indexPath.row] else {
             return cell
         }
        let date = forecast.date
        let startIndex = date.index(date.startIndex, offsetBy: 5)
        let secondHalf = String(date[startIndex...])
        cell.dateLabel.text = secondHalf
        
            cell.temperatureLabel.text = "\(forecast.averageTemperature)°"
            
            var imageName = forecast.condition
            if forecast.condition == "Overcast" || forecast.condition == "Cloudy"{
                imageName = "cloudy"
            } else if forecast.condition == "Partly cloudy" {
                imageName = "parcloudy"
            } else if forecast.condition == "Sunny" || forecast.condition == "Clear" {
                imageName = "sunny"
            } else if forecast.condition.lowercased().contains("rain") || forecast.condition.lowercased().contains("drizzle") {
                imageName = "rain"
            }

            cell.conditionImageView.image = UIImage(named: imageName)
            
            return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        setupBackground()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        cityLabel.textColor = UIColor.white

        temperatureLabel.font = UIFont.systemFont(ofSize: 72, weight: .regular)
        temperatureLabel.textColor = UIColor.white

        conditionLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        conditionLabel.textColor = UIColor.white

        updateUI()
        
    }
    
    func setupBackground() {
        guard let weather = weather else { return }
        backgroundImageView = UIImageView(frame: view.bounds)
        
        var imageName = weather.condition
        if weather.condition == "Overcast" || weather.condition ==  "Cloudy" {
            imageName = "cloudy"
        }
        else if weather.condition == "Partly cloudy" {
            imageName = "parcloudy"
        }
        else if weather.condition == "Sunny" || weather.condition == "Clear"{
            imageName = "sunny"
        }
        else if weather.condition.lowercased().contains("rain") || weather.condition.lowercased().contains("drizzle") {
            imageName = "rain"
        }
        
        backgroundImageView.image = UIImage(named: "\(imageName)_big")
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func updateUI() {
        guard let weather = weather else { return }
        cityLabel.text = weather.city
        temperatureLabel.text = "\(weather.temperature)°"
        conditionLabel.text = weather.condition
    }
}

