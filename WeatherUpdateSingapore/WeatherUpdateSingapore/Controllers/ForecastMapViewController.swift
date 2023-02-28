//
//  ForecastMapViewController.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/28/23.
//

import UIKit
import GoogleMaps

class ForecastMapViewController: UIViewController {
    
    var mapView: GMSMapView!
    private var infoWindow = TrafficMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    var updatedAirTempDict = [UpdatedAirTempInfoData]()
    var updatedRainForecastDict = [UpdatedRainFallInfoData]()
    var updatedRelativeHumidityForecatDict = [UpdatedRelativeInfoData]()
    var updatedWindDirectionForecastDict = [UpdatedWindDirectionValueInfoData]()
    var updatedWindSpeedForecastDict = [UpdatedWindSpeedValueInfoData]()
    var updatedTrafficImagesWithInfoDict = [UpdatedTrafficImageInfoData]()
    var updatedTwoHourWeatherDict = [UpdatedWeatherInfoData]()
    
    var isAirTemp: Bool = false
    var isRainTemp: Bool = false
    var isHumidityTemp: Bool = false
    var isWindDirection: Bool = false
    var isWindSpeed: Bool = false
    var isTrafficImage: Bool = false
    var isTwoDayForecast: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if isTrafficImage {
            self.infoWindow = loadNiB()
        }
        createMapView()
        displayMultipleLocationInMapkit()
    }
    
    func createMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.375, longitude: 103.839, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func loadNiB() -> TrafficMarkerWindow {
        let infoWindow = TrafficMarkerWindow.instanceFromNib() as! TrafficMarkerWindow
        return infoWindow
    }
    
    func displayMultipleLocationInMapkit(){
        
        if isAirTemp {
            
            for item in updatedAirTempDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.airTemp))
            }
        } else if isTwoDayForecast {
            for item in updatedTwoHourWeatherDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.forecastTwoDay))
            }
        } else if isRainTemp {
            
            for item in updatedRainForecastDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.rainfallValue))
            }
        } else if isHumidityTemp {
            
            for item in updatedRelativeHumidityForecatDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.relativeHumidityTemp))
                
            }
        } else if isWindDirection {
            
            for item in updatedWindDirectionForecastDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.windDirectionTemp))
            }
        } else if isWindSpeed {
            for item in updatedWindSpeedForecastDict {
                
                plotMarkers(lattitude: item.lattitude, longitude: item.longitude, name: item.name, snippetValue: String(item.windSpeedTemp))
            }
        } else if isTrafficImage {
            
            for item in updatedTrafficImagesWithInfoDict {
                                
                let lattitude = Double(item.lattitude)
                let longitude = Double(item.longitude)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                marker.map = mapView
                marker.userData = item
            }
            
        }
    }
    
    func plotMarkers(lattitude: Double, longitude: Double, name: String, snippetValue: String) {
        
        let lattitude = Double(lattitude)
        let longitude = Double(longitude)
        print(lattitude, longitude)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        marker.title = name
        marker.snippet = snippetValue
        marker.map = mapView
    }
}

//MARK: Map Delegate Methods
extension ForecastMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if isTrafficImage {
        var imgUrlStr = "https://images.data.gov.sg/api/traffic-images/2023/02/e45c730c-59fa-484f-bb90-bd8f6323733d.jpg"

        if let data = marker.userData! as? UpdatedTrafficImageInfoData {
            imgUrlStr = data.trafficImgUrl
        }
        
        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        // Configure UI properties of info window
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 5
        infoWindow.layer.borderWidth = 1
        infoWindow.layer.borderColor = UIColor.black.cgColor
        
        infoWindow.trafficImageView.load(url: URL(string: imgUrlStr)!)
        
        // Offset the info window to be directly above the tapped marker
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 82
        self.view.addSubview(infoWindow)
        return false
        }
        return false
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if isTrafficImage {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 82
        }
        }
    }
        
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isTrafficImage {
         infoWindow.removeFromSuperview()
        }
    }
}

