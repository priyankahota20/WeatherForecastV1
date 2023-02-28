//
//  TrafficImageInfoModel.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import Foundation

// MARK: - TrafficImageInfoData
struct TrafficImageInfoData: Decodable {
    let trafficImageItems: [TrafficImageItem]
    let trafficImageApiInfo: TrafficImageApiInfo

    enum CodingKeys: String, CodingKey {
        case trafficImageItems = "items"
        case trafficImageApiInfo = "api_info"
    }
}

// MARK: - TrafficImageApiInfo
struct TrafficImageApiInfo: Decodable {
    let status: String
}

// MARK: - TrafficImageItem
struct TrafficImageItem: Decodable {
    let timestamp: String
    let cameras: [Camera]
}

// MARK: - Camera
struct Camera: Decodable {
    let timestamp: String
    let image: String
    let location: Location
    let cameraID: String
    let imageMetadata: ImageMetadata

    enum CodingKeys: String, CodingKey {
        case timestamp, image, location
        case cameraID = "camera_id"
        case imageMetadata = "image_metadata"
    }
}

// MARK: - ImageMetadata
struct ImageMetadata: Decodable {
    let height, width: Int
    let md5: String
}

// MARK: - Location
struct Location: Decodable {
    let latitude, longitude: Double
}

