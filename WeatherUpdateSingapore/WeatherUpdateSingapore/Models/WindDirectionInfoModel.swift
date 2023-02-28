//
//  WindDirectionInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - WindDirectionInfoData
struct WindDirectionInfoData: Decodable {
    let windDirectionMetadata: WindDirectionMetadata
    let windDirectionItems: [WindDirectionItem]
    let windDirectionApiInfo: WindDirectionApiInfo

    enum CodingKeys: String, CodingKey {
        case windDirectionMetadata = "metadata"
        case windDirectionItems = "items"
        case windDirectionApiInfo = "api_info"
    }
}

// MARK: - WindDirectionApiInfo
struct WindDirectionApiInfo: Decodable {
    let status: String
}

// MARK: - WindDirectionItem
struct WindDirectionItem: Decodable {
    let timestamp: String
    let windDirectionReadings: [WindDirectionReadings]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case windDirectionReadings = "readings"
    }
}

// MARK: - WindDirectionReadings
struct WindDirectionReadings: Decodable {
    let stationID: String
    let windDirectionValue: Int

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case windDirectionValue = "value"
    }
}

// MARK: - WindDirectionMetadata
struct WindDirectionMetadata: Decodable {
    let windDirectionStations: [WindDirectionStations]
    let readingType, readingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case windDirectionStations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
}

// MARK: - WindDirectionStations
struct WindDirectionStations: Decodable {
    let locationId: String
    let deviceID: String
    let locationName: String
    let windDirectionLocation: WindDirectionLocation
    
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case deviceID = "device_id"
        case locationName = "name"
        case windDirectionLocation = "location"
    }
}

struct WindDirectionLocation: Decodable {
    let latitude, longitude: Double
}
