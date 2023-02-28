//
//  RelativeHumidityInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - RelativeHumidityInfoData
struct RelativeHumidityInfoData: Decodable {
    let relativeHumidityMetadata: RelativeHumidityMetadata
    let relativeHumidityItems: [RelativeHumidityItem]
    let relativeHumidityApiInfo: RelativeHumidityApiInfo

    enum CodingKeys: String, CodingKey {
        case relativeHumidityMetadata = "metadata"
        case relativeHumidityItems = "items"
        case relativeHumidityApiInfo = "api_info"
    }
}

// MARK: - RelativeHumidityApiInfo
struct RelativeHumidityApiInfo: Decodable {
    let status: String
}

// MARK: - RelativeHumidityItem
struct RelativeHumidityItem: Decodable {
    let timestamp: String
    let relativeHumidityReadings: [RelativeHumidityReadings]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case relativeHumidityReadings = "readings"
    }
}

// MARK: - RelativeHumidityReadings
struct RelativeHumidityReadings: Decodable {
    let stationID: String
    let relativeHumidityValue: Double

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case relativeHumidityValue = "value"
    }
}

// MARK: - RelativeHumidityMetadata
struct RelativeHumidityMetadata: Decodable {
    let relativeHumidityStations: [RelativeHumidityStations]
    let readingType, readingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case relativeHumidityStations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
}

// MARK: - RelativeHumidityStations
struct RelativeHumidityStations: Decodable {
    let locationId: String
    let deviceID: String
    let locationName: String
    let relativeHumidityLocation: RelativeHumidityLocation
    
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case deviceID = "device_id"
        case locationName = "name"
        case relativeHumidityLocation = "location"
    }
}

// MARK: - RelativeHumidityLocation
struct RelativeHumidityLocation: Decodable {
    let latitude, longitude: Double
}
