//
//  WeatherService.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 7/13/25.
//
import Foundation

class WeatherService {
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        let apiKey = "fa805031f5b27787421c441e3a9b5ad4"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("⛔ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

