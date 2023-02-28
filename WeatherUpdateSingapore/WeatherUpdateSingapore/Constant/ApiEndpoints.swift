//
//  ApiEndpoints.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

//MARK: API Endpoints
enum ApiEndpoints: String {

    case twoHourWeatherForcast = "/2-hour-weather-forecast"
    case airTemperature = "/air-temperature"
    case rainfall = "/rainfall"
    case relativeHumidity = "/relative-humidity"
    case windDirection = "/wind-direction"
    case windSpeed = "/wind-speed"
    case trafficImages = "/traffic-images"

}
