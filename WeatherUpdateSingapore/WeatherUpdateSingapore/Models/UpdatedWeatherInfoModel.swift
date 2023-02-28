//
//  UpdatedWeatherInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

struct UpdatedWeatherInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let forecastTwoDay: String
    
}

struct UpdatedAirTempInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let airTemp: Double
}

struct UpdatedRainFallInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let rainfallValue: Int
}

struct UpdatedRelativeInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let relativeHumidityTemp: Double
}

struct UpdatedWindDirectionValueInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let windDirectionTemp: Int
}

struct UpdatedWindSpeedValueInfoData {
    
    let name: String
    let lattitude: Double
    let longitude: Double
    let windSpeedTemp: Double
}

struct UpdatedTrafficImageInfoData {
    
    let lattitude: Double
    let longitude: Double
    let trafficImgUrl: String
}


