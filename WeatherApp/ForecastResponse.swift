//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 9/28/25.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [DailyForecast]
}

struct DailyForecast: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let main: MainClass
    let weather: [ForecastWeather]

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
    }
}

struct MainClass: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let description: String
    let icon: String
}


extension Array where Element == DailyForecast {
    func groupedByDay() -> [(date: Date, avgTemp: Double)] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: self) { forecast in
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            return calendar.startOfDay(for: date)
        }

        return grouped.map { (day, forecasts) in
            let avg = forecasts.map { $0.main.temp }.reduce(0, +) / Double(forecasts.count)
            return (date: day, avgTemp: avg)
        }
        .sorted { $0.date < $1.date }
    }
}



