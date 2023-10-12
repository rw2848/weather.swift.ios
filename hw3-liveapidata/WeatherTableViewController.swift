//
//  WeatherTableViewController.swift
//  hw2-datadisplayintable
//
//  Created by Runwei Wang on 9/27/23.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    var sucess = false
    var weatherData: [CityWeather] = []
    let apiClient = APIClient()
    let locations = ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose", "Shanghai", "Beijing", "Chengdu", "Seoul"]
    
    // Navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "Fetching weather ... ⏳"
        
        Task {
            await fetchWeatherData()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            let currentTime = formatter.string(from: Date())
            sucess = true
            self.navigationItem.title = "Last updated: \(currentTime) 🔥"
        }
        
    }
    
    func fetchWeatherData() async {
        var fetchedWeatherData: [CityWeather] = []

        for city in locations {
            do {
                let (data, _, error) = try await apiClient.fetchData(for: city, days: 3)
                
                if let error = error as? URLError {
                    print("Error fetching weather data for \(city):", error)
                    
                    switch error.code {
                    case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                        // Notify user of a potential network issue
                        DispatchQueue.main.async {
                            self.showNetworkErrorAlert()
                        }
                    default:
                        // Handle other errors or continue
                        print("Some other error occurred for \(city):", error)
                    }

                    continue
                }
                
                guard let data = data else {
                    print("No data received for \(city).")
                    continue
                }
                
                let weatherJSONData = try JSONDecoder().decode(WeatherJSON.self, from: data)
                let hourlyTemperatures: [HourlyTemperature] = weatherJSONData.forecast.forecastday[0].hour.map { hourData in
                    HourlyTemperature(hour: hourData.time, temperature: Int(hourData.tempC), condition: hourData.condition.text)
                }

                let threeDayForecast: [DailyForecast] = weatherJSONData.forecast.forecastday.map { dailyData in
                    DailyForecast(date: dailyData.date, averageTemperature: Int(dailyData.day.avgtempC), condition: dailyData.day.condition.text)
                }

                let cityWeather = CityWeather(
                    city: weatherJSONData.location.name,
                    temperature: Int(weatherJSONData.current.tempC),
                    condition: weatherJSONData.current.condition.text,
                    hourlyTemperatures: hourlyTemperatures,
                    threeDayForecast: threeDayForecast
                )

                fetchedWeatherData.append(cityWeather)
                
            } catch {
                print("Error processing data for \(city):", error)
            }
            
        }

        DispatchQueue.main.async {
            self.weatherData = fetchedWeatherData
            for cityWeather in self.weatherData {
                print("\(cityWeather.city) - \(cityWeather.temperature)°C - \(cityWeather.condition)  - \(cityWeather.hourlyTemperatures[0]) - \(cityWeather.threeDayForecast[0])")
            }
            self.tableView.reloadData()
        }
    }
    
    func showNetworkErrorAlert() {
        let alertController = UIAlertController(
            title: "Oops!!",
            message: "🆘 We couldn't update the data. Please check your connection and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.navigationItem.title = "Last updated: Who knows 💩"
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    // Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherCell
        
        let weather = weatherData[indexPath.row]
        cell.cityLabel?.text = weather.city
        cell.temperatureLabel?.text = "\(weather.temperature)°"
        cell.conditionLabel?.text = weather.condition
        
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
        
        cell.conditionImageView?.image = UIImage(named: imageName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = weatherData[sourceIndexPath.row]
        weatherData.remove(at: sourceIndexPath.row)
        weatherData.insert(movedObject, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Click for Details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destinationVC = segue.destination as? WeatherDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.weather = weatherData[indexPath.row]
        }
    }
}
