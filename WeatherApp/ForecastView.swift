import SwiftUI

struct ForecastView: View {
    @StateObject private var forecastViewModel = ForecastViewModel()
    var city: String

    var body: some View {
        VStack {
            if forecastViewModel.dailyForecasts.isEmpty {
                if let error = forecastViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ProgressView("Loading forecast...")
                }
            } else {
                List(forecastViewModel.dailyForecasts, id: \.date) { day in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(day.date.formatted(.dateTime.weekday(.wide)))
                                .font(.headline)
                            Spacer()
                            Text(day.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.gray)
                        }
                        Text("🌡 Avg Temp: \(day.avgTemp, specifier: "%.1f")°C")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("7-Day Forecast")
        .onAppear {
            forecastViewModel.fetchForecast(for: city)
        }
    }
}
