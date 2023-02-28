//
//  WeatherForecastModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: WeatherForecast

struct WeatherForecastData: Decodable {
    let areaMetadata: [AreaMetadatum]
    let items: [Item]
    let apiInfo: APIInfo
    
    enum CodingKeys: String, CodingKey {
        case areaMetadata = "area_metadata"
        case items
        case apiInfo = "api_info"
    }
}

// MARK: - APIInfo
struct APIInfo: Decodable {
    let status: String
}

// MARK: - AreaMetadatum
struct AreaMetadatum: Decodable {
    let name: String
    let labelLocation: LabelLocation
    
    enum CodingKeys: String, CodingKey {
        case name
        case labelLocation = "label_location"
    }
}

// MARK: - LabelLocation
struct LabelLocation: Decodable {
    let latitude, longitude: Double
}

// MARK: - Item
struct Item: Decodable {
    let updateTimestamp, timestamp: String
    let validPeriod: ValidPeriod
    let forecasts: [ForecastElement]
    
    enum CodingKeys: String, CodingKey {
        case updateTimestamp = "update_timestamp"
        case timestamp
        case validPeriod = "valid_period"
        case forecasts
    }
}

// MARK: - ForecastElement
struct ForecastElement: Decodable {
    let area: String
    let forecast: String
}

//enum ForecastEnum: String, Decodable {
//    case partlyCloudyDay = "Partly Cloudy (Day)"
//}

// MARK: - ValidPeriod
struct ValidPeriod: Decodable {
    let start, end: String
}

