//
//  MapViewController.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/26/23.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
 
    var mapView: GMSMapView!
    private var infoWindow = MarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    var updatedWeatherDict = [UpdatedWeatherInfoData]()
    var updatedAirTempDict = [UpdatedAirTempInfoData]()
    var updatedRainForecastDict = [UpdatedRainFallInfoData]()
    var updatedRelativeHumidityForecatDict = [UpdatedRelativeInfoData]()
    var updatedWindDirectionForecastDict = [UpdatedWindDirectionValueInfoData]()
    var updatedWindSpeedForecastDict = [UpdatedWindSpeedValueInfoData]()
    var updatedTrafficImagesWithInfoDict = [UpdatedTrafficImageInfoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.infoWindow = loadNiB()
        createMapView()
        displayMultipleLocationInMapkit()       
    }
    
    func createMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.375, longitude: 103.839, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func displayMultipleLocationInMapkit(){
        
        for item in updatedWeatherDict {
            
            let lattitude = Double(item.lattitude)
            let longitude = Double(item.longitude)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
            marker.map = mapView
            marker.userData = item
        }
    }

    func loadNiB() -> MarkerWindow {
        let infoWindow = MarkerWindow.instanceFromNib() as! MarkerWindow
        return infoWindow
    }
    
    
}

//MARK: Map Delegate Methods
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
      //  var markerData: UpdatedWeatherInfoData
        var locationName = ""
        var twoDayForecast = ""
        var airTempForecast = 0.0
        var rainfallForecast = 0
        var relativeHumidityForecast = 0.0
        var windDirectionForeCast = 0
        var windSpeedForecast = 0.0
        var imageUrl = "https://images.data.gov.sg/api/traffic-images/2023/02/e45c730c-59fa-484f-bb90-bd8f6323733d.jpg"
        
        if let data = marker.userData! as? UpdatedWeatherInfoData {
           // markerData = data
            locationName = data.name
            twoDayForecast = data.forecastTwoDay
            
             for airTemp in updatedAirTempDict {
                if (airTemp.name == data.name) {
                    airTempForecast = airTemp.airTemp
                }
            }
    
            for rainfall in updatedRainForecastDict {
               if (rainfall.name == data.name) {
                   rainfallForecast = rainfall.rainfallValue
               }
           }
            
            for relativeHumidity in updatedRelativeHumidityForecatDict {
               if (relativeHumidity.name == data.name) {
                   relativeHumidityForecast = relativeHumidity.relativeHumidityTemp
               }
           }
            
            for windDirection in updatedWindDirectionForecastDict {
               if (windDirection.name == data.name) {
                   windDirectionForeCast = windDirection.windDirectionTemp
               }
           }
            
            for windSpeed in updatedWindSpeedForecastDict {
               if (windSpeed.name == data.name) {
                   windSpeedForecast = windSpeed.windSpeedTemp
               }
           }
            for trafficImage in updatedTrafficImagesWithInfoDict {
                if (trafficImage.lattitude.rounded(toPlaces: 2) == data.lattitude.rounded(toPlaces: 2) && (trafficImage.longitude.rounded(toPlaces: 2) == data.longitude.rounded(toPlaces: 2))) {
                   
                    imageUrl = trafficImage.trafficImgUrl
               }
           }
            
        }

        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
     
        // Configure UI properties of info window
        infoWindow.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 5
        infoWindow.layer.borderWidth = 0.5
        infoWindow.layer.borderColor = UIColor.black.cgColor
        

        infoWindow.locationNameLabel.text = locationName
        infoWindow.airTemperatureLabel.text = String(airTempForecast)
        infoWindow.RainfallLabel.text = String(rainfallForecast)
        infoWindow.relativeHumidityLabel.text = String(relativeHumidityForecast)
        infoWindow.windDirectionLabel.text = String(windDirectionForeCast)
        infoWindow.windSpeedLabel.text = String(windSpeedForecast)
        infoWindow.TwoDayWeatherFprecastLabel.text = twoDayForecast
        infoWindow.trafficImageView.load(url: URL(string: imageUrl)!)
        
        
        
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 200
        self.view.addSubview(infoWindow)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 200
        }
    }
        
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }

}
