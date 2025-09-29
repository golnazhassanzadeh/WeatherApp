import Foundation

class ForecastViewModel: ObservableObject {
    @Published var dailyForecasts: [(date: Date, avgTemp: Double)] = []
    @Published var errorMessage: String? = nil

    func fetchForecast(for city: String) {
        let apiKey = "fa805031f5b27787421c441e3a9b5ad4"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            self.errorMessage = "❌ Invalid URL"
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)

    
                let grouped = decoded.list.groupedByDay()

                DispatchQueue.main.async {
                    self.dailyForecasts = Array(grouped.prefix(7))
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "⚠️ Could not fetch forecast"
                    self.dailyForecasts = []
                }
            }
        }
    }
}
