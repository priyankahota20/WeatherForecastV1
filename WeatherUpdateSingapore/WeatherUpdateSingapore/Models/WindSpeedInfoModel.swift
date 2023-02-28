//
//  WindSpeedInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - WindSpeedInfoData
struct WindSpeedInfoData: Decodable {
    let windSpeedMetadata: WindSpeedMetadata
    let windSpeedItems: [WindSpeedItem]
    let windSpeedApiInfo: WindSpeedApiInfo

    enum CodingKeys: String, CodingKey {
        case windSpeedMetadata = "metadata"
        case windSpeedItems = "items"
        case windSpeedApiInfo = "api_info"
    }
}

// MARK: - WindSpeedApiInfo
struct WindSpeedApiInfo: Decodable {
    let status: String
}

// MARK: - WindSpeedItem
struct WindSpeedItem: Decodable {
    let timestamp: String
    let windSpeedReadings: [WindSpeedReadings]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case windSpeedReadings = "readings"
    }
}

// MARK: - WindSpeedReadings
struct WindSpeedReadings: Decodable {
    let stationID: String
    let windSpeedValue: Double

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case windSpeedValue = "value"
    }
}

// MARK: - WindSpeedMetadata
struct WindSpeedMetadata: Decodable {
    let windSpeedStations: [WindSpeedStations]
    let readingType, readingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case windSpeedStations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
}

// MARK: - WindSpeedStations
struct WindSpeedStations: Decodable {
    let locationId: String
    let deviceID: String
    let locationName: String
    let windSpeedLocation: WindSpeedLocation
    
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case deviceID = "device_id"
        case locationName = "name"
        case windSpeedLocation = "location"
    }
}

struct WindSpeedLocation: Decodable {
    let latitude, longitude: Double
}

