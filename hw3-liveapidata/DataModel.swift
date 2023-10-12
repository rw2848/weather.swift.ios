//
//  File.swift
//  hw3-liveapidata
//
//  Created by Runwei Wang on 10/10/23.
//

struct CityWeather {
    let city: String
    let temperature: Int
    let condition: String
    let hourlyTemperatures: [HourlyTemperature]
    let threeDayForecast: [DailyForecast]
}

struct HourlyTemperature {
    let hour: String
    let temperature: Int
    let condition: String
}

struct DailyForecast {
    let date: String
    let averageTemperature: Int
    let condition: String
}
