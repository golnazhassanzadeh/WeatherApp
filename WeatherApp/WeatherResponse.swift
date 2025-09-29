//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 7/13/25.
//

import Foundation

struct WeatherResponse: Codable ,Equatable {
    let name: String
    let main: Main
    let weather: [CurrentWeather]
    let wind: Wind
}

struct Main: Codable ,Equatable{
    let temp: Double
    let feels_like: Double
}

struct CurrentWeather: Codable,Equatable {
    let description: String
    let icon: String
}

struct Wind: Codable,Equatable {
    let speed: Double
}
