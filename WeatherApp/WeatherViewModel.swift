//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 7/13/25.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String? = nil


    func fetchWeather(for city: String) {
        let apiKey = "fa805031f5b27787421c441e3a9b5ad4"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "❌ Invalid URL"
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weather = decoded
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "⚠️ Could not fetch weather. Check city name or internet."
                    self.weather = nil
                }
            }
        }
    }
}

