//
//  ContentView.swift
//  WeatherApp
//
//  Created by golnaz Hassanzade on 7/13/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var city: String = ""
    @State private var showWeatherDetails = false


    var body: some View {
        NavigationView{
            ZStack{
                // 🌄 Dynamic background based on weather description
                Image(backgroundImageName(for: viewModel.weather?.weather.first?.description ?? ""))
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: viewModel.weather?.weather.first?.description)
                
                VStack(spacing: 40) {
                    TextField("Enter city name", text: $city)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    Button("Get Weather") {
                        showWeatherDetails = false
                        viewModel.fetchWeather(for: city)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    
                    if let weather = viewModel.weather , showWeatherDetails{
                        VStack(spacing: 8) {
                            Text("🌍 City: \(weather.name)")
                                .padding(1)
                            Text("🌡️ Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                                .padding(.top)
                            
                            HStack {
                                Text("☁️ Description: \(weather.weather.first?.description ?? "-")")
                                
                                if let icon = weather.weather.first?.icon {
                                    let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    } placeholder: {
                                        Image(systemName: "cloud.sun.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.gray)
                                            .opacity(0.5)
                                    }
                                }
                            }
                            Text("💨 Wind Speed: \(weather.wind.speed, specifier: "%.1f") m/s")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.weather?.name)
                        NavigationLink("7-Day Forecast") {
                            ForecastView(city: city)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    } else {
                        Text("Please enter a city and tap the button")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .onAppear {
                if let gpsCity = locationManager.city {
                    city = gpsCity
                    viewModel.fetchWeather(for: gpsCity)
                }
            }
            .onReceive(locationManager.$city) { gpsCity in
                if let gpsCity = gpsCity {
                    city = gpsCity
                    showWeatherDetails = false
                    viewModel.fetchWeather(for: gpsCity)
                }
            }
            .onChange(of: viewModel.weather) {
                if viewModel.weather != nil {
                    withAnimation {
                        showWeatherDetails = true
                    }
                }
            }
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }

    //  Choose background based on weather description
    func backgroundImageName(for description: String) -> String {
        let lowercased = description.lowercased()

        if lowercased.contains("clear") || lowercased.contains("sun") {
            return "sunnyBackground"
        } else if lowercased.contains("cloud") {
            return "cloudyBackground"
        } else if lowercased.contains("rain") || lowercased.contains("drizzle") {
            return "rainyBackground"
        } else if lowercased.contains("snow") {
            return "snowyBackground"
        }else if lowercased.contains("fog"){
                return "foggyBackground"
            }
        else {
            return "weatherBackground" // default fallback
        }
    }
}


#Preview {
    ContentView() }
