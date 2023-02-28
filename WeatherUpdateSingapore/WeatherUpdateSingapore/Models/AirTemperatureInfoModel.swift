//
//  AirTemperatureInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - AirTemperatureInfoData
struct AirTemperatureInfoData: Decodable {
    
    let airTempMetadata: AirTempMetadata
    let airTempItems: [AirTempItem]
    let airTempApiInfo: AirTempApiInfo
    
    enum CodingKeys: String, CodingKey {
        case airTempMetadata = "metadata"
        case airTempItems = "items"
        case airTempApiInfo = "api_info"
    }
}

// MARK: - APIInfo
struct AirTempApiInfo: Decodable {
    let status: String
}

// MARK: - Item
struct AirTempItem: Decodable {
    let timestamp: String
    let airTempReadings: [AirTempReading]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case airTempReadings = "readings"
    }
}

// MARK: - Reading
struct AirTempReading: Decodable {
    let stationID: String
    let airTempValue: Double
    
    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case airTempValue = "value"
    }
}

// MARK: - AirTempMetadata
struct AirTempMetadata: Decodable {
    let airTempStations: [AirTempStations]
    let readingType, readingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case airTempStations = "stations"
        case readingType = "reading_type"
        case readingUnit = "reading_unit"
    }
    
}

// MARK: - Station
struct AirTempStations: Decodable {
    let locationId: String
    let deviceID: String
    let locationName: String
    let airTemplocation: AirTempLocation
    
    enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case deviceID = "device_id"
        case locationName = "name"
        case airTemplocation = "location"
    }
}

struct AirTempLocation: Decodable {
    let latitude, longitude: Double
}
