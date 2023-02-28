//
//  RainfallInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - RainfallInfoData
struct RainfallInfoData: Decodable {
    let rainfallMetadata: RainfallMetadata
    let rainfallItems: [RainfallItem]
    let rainfallApiInfo: RainfallApiInfo

    enum CodingKeys: String, CodingKey {
        case rainfallMetadata = "metadata"
        case rainfallItems = "items"
        case rainfallApiInfo = "api_info"
    }
}

// MARK: - RainfallApiInfo
struct RainfallApiInfo: Decodable {
    let status: String
}

// MARK: - RainfallItem
struct RainfallItem: Decodable {
    let timestamp: String
    let rainfallReadings: [RainfallReadings]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case rainfallReadings = "readings"
    }
}

// MARK: - RainfallReadings
struct RainfallReadings: Decodable {
    let stationID: String
    let rainfallValue: Int

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case rainfallValue = "value"
    }
}

// MARK: - RainfallMetadata
struct RainfallMetadata: Decodable {
    let rainfallStations: [RainfallStations]
    let readingType, readingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case rainfallStations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
}

// MARK: - RainfallStations
struct RainfallStations: Decodable {
    let locationId: String
    let deviceID: String
    let locationName: String
    let rainfalllocation: Rainfalllocation
    
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case deviceID = "device_id"
        case locationName = "name"
        case rainfalllocation = "location"
    }
}

struct Rainfalllocation: Decodable {
    let latitude, longitude: Double
}
