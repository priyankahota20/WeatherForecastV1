//
//  InitialViewController.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/25/23.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var selectedDateTimeTextField: UITextField!
    @IBOutlet weak var checkWeatherUpdateButton: UIButton!
    
    let datePicker = UIDatePicker()
    let apiService = ApiService()
    let dispatchGroup = DispatchGroup()
    var activityLoader = UIAlertController()
    
    var weatherUpdateDict = [UpdatedWeatherInfoData]()
    var airTempDict = [UpdatedAirTempInfoData]()
    var rainForecastDict = [UpdatedRainFallInfoData]()
    var relativeHumidityForecatDict = [UpdatedRelativeInfoData]()
    var windDirectionForecastDict = [UpdatedWindDirectionValueInfoData]()
    var windSpeedForecastDict = [UpdatedWindSpeedValueInfoData]()
    var trafficImagesWithInfoDict = [UpdatedTrafficImageInfoData]()
    
    var isTwoDayForecastClicked = false
    var isAirTempClicked = false
    var isRainTempClicked: Bool = false
    var isHumidityTempClicked: Bool = false
    var isWindDirectionClicked: Bool = false
    var isWindSpeedClicked: Bool = false
    var isTrafficImageClicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectedDateTimeTextField.delegate = self
        createDateTimePicker()
        print(ApiEndpoints.twoHourWeatherForcast.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearData()
    }
    
    
    //MARK: GET API Methods
    func getApiDataForTwoHourWeatherForecast() {
    
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.twoHourWeatherForcast.rawValue)?\(requestParameterStr)"
        print(urlString)
        let weatherForecastURL = URL(string: urlString)!
        apiService.getApiData(requestURL: weatherForecastURL, resultType: WeatherForecastData.self) { weatherForecastResult in
            
            print("@@@@TWOHOUR")
            var foreCastReport = ""
            if weatherForecastResult.areaMetadata.count != 0 {
                
                for weatherForecast in weatherForecastResult.areaMetadata {
                    
                    if weatherForecastResult.items.count != 0  {
                        
                        for foreCastData in weatherForecastResult.items {
                            
                            if foreCastData.forecasts.count != 0 {
                                
                                for forecastItem in foreCastData.forecasts {
                                    
                                    if weatherForecast.name == forecastItem.area {
                                        foreCastReport = forecastItem.forecast
                                    }
                                }
                            }
                        }
                    }
                    let updatedWeatherInfo =  UpdatedWeatherInfoData(name: weatherForecast.name , lattitude: weatherForecast.labelLocation.latitude, longitude: weatherForecast.labelLocation.longitude, forecastTwoDay: foreCastReport)
                    self.weatherUpdateDict.append(updatedWeatherInfo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isTwoDayForecastClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }
    
    func getApiForAirTemperatureInfo() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.airTemperature.rawValue)?\(requestParameterStr)"
        let airTempURL = URL(string: urlString)!
        print(urlString)
        
        apiService.getApiData(requestURL: airTempURL, resultType: AirTemperatureInfoData.self) { airTemperatureInfoResult in
            
            print("@@@@AIRTEMP")
            var airTempReading = 0.0

            if airTemperatureInfoResult.airTempMetadata.airTempStations.count != 0 {
                
                for airTempStation in airTemperatureInfoResult.airTempMetadata.airTempStations {
                    
                    if airTemperatureInfoResult.airTempItems.count != 0 {
                        
                        for airTemp in airTemperatureInfoResult.airTempItems {
                            
                            if airTemp.airTempReadings.count != 0 {
                                
                                for airTempItem in airTemp.airTempReadings {
                                    
                                    if airTempStation.locationId == airTempItem.stationID {
                                        
                                        airTempReading = airTempItem.airTempValue
                                    }
                                }
                            }
                        }
                    }
                    let updatedAirTempInfo =  UpdatedAirTempInfoData(name: airTempStation.locationName, lattitude: airTempStation.airTemplocation.latitude, longitude: airTempStation.airTemplocation.longitude, airTemp: airTempReading)
                    self.airTempDict.append(updatedAirTempInfo)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isAirTempClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }

        }
    }
    
    func getApiForRainfallInfo() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.rainfall.rawValue)?\(requestParameterStr)"
        let rainfallURL = URL(string: urlString)!
        print(urlString)
        
        apiService.getApiData(requestURL: rainfallURL, resultType: RainfallInfoData.self) { rainfallInfoResult in
            print("@@@@RAINFALL")
         //   self.dispatchGroup.leave()
            var rainfallReading = 0
            
            if rainfallInfoResult.rainfallMetadata.rainfallStations.count != 0 {
                
                for rainfallData in rainfallInfoResult.rainfallMetadata.rainfallStations {

                    if rainfallInfoResult.rainfallItems.count != 0 {
                        
                        for forecast in rainfallInfoResult.rainfallItems {
                            
                            if forecast.rainfallReadings.count != 0 {
                                
                                for forecastItem in forecast.rainfallReadings {
                                    
                                    if rainfallData.locationId == forecastItem.stationID {
                                        
                                        rainfallReading = forecastItem.rainfallValue
                                    }
                                }
                            }
                        }
                    }
                    let updatedRainfallTempInfo = UpdatedRainFallInfoData(name: rainfallData.locationName, lattitude: rainfallData.rainfalllocation.latitude, longitude: rainfallData.rainfalllocation.longitude, rainfallValue: rainfallReading)
                    self.rainForecastDict.append(updatedRainfallTempInfo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isRainTempClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }

    func getApiForRelativeHumidityInfo() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.relativeHumidity.rawValue)?\(requestParameterStr)"
        let relativeHumidityURL = URL(string: urlString)!
        print(urlString)
        
        apiService.getApiData(requestURL: relativeHumidityURL, resultType: RelativeHumidityInfoData.self) { relativeHumidityInfoResult in
            
            print("@@@@RELATIVEINFO")
            
         //   self.dispatchGroup.leave()
            var relativeHumidityReading = 0.0
            
            if relativeHumidityInfoResult.relativeHumidityMetadata.relativeHumidityStations.count != 0 {
                
                for relativeHumidityData in relativeHumidityInfoResult.relativeHumidityMetadata.relativeHumidityStations {

                    if relativeHumidityInfoResult.relativeHumidityItems.count != 0 {
                        
                        for forecast in relativeHumidityInfoResult.relativeHumidityItems {
                            
                            if forecast.relativeHumidityReadings.count != 0 {
                                
                                for forecastItem in forecast.relativeHumidityReadings {
                                    
                                    if relativeHumidityData.locationId == forecastItem.stationID {
                                        
                                        relativeHumidityReading = forecastItem.relativeHumidityValue
                                    }
                                }
                            }
                        }
                    }
                    let updatedRelativeHumidityTempInfo = UpdatedRelativeInfoData(name: relativeHumidityData.locationName, lattitude: relativeHumidityData.relativeHumidityLocation.latitude, longitude: relativeHumidityData.relativeHumidityLocation.longitude, relativeHumidityTemp: relativeHumidityReading)
                    self.relativeHumidityForecatDict.append(updatedRelativeHumidityTempInfo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isHumidityTempClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }
    
    func getApiForWindDirection() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.windDirection.rawValue)?\(requestParameterStr)"
        let windDirectionURL = URL(string: urlString)!
        print(urlString)

        apiService.getApiData(requestURL: windDirectionURL, resultType: WindDirectionInfoData.self) { windDirectionInfoResult in
            
            print("@@@@WINDDIRECTION")
         //   self.dispatchGroup.leave()
            
            var windDirectionReading = 0
            
            if windDirectionInfoResult.windDirectionMetadata.windDirectionStations.count != 0 {
                
                for windDirectionData in windDirectionInfoResult.windDirectionMetadata.windDirectionStations {

                    if windDirectionInfoResult.windDirectionItems.count != 0 {
                        
                        for forecast in windDirectionInfoResult.windDirectionItems {
                            
                            if forecast.windDirectionReadings.count != 0 {
                                
                                for forecastItem in forecast.windDirectionReadings {
                                    
                                    if windDirectionData.locationId == forecastItem.stationID {
                                        
                                        windDirectionReading = forecastItem.windDirectionValue
                                    }
                                }
                            }
                        }
                    }
                    let updatedWindDirectionInfo = UpdatedWindDirectionValueInfoData(name: windDirectionData.locationName, lattitude: windDirectionData.windDirectionLocation.latitude, longitude: windDirectionData.windDirectionLocation.longitude, windDirectionTemp: windDirectionReading)
                    
                    self.windDirectionForecastDict.append(updatedWindDirectionInfo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isWindDirectionClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }
    
    func getApiForWindSpeed() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: false)
        let urlString = "\(AppConstant.baseUrl)\(ApiEndpoints.windSpeed.rawValue)?\(requestParameterStr)"
        let windSpeedURL = URL(string: urlString)!
        print(urlString)
        
        apiService.getApiData(requestURL: windSpeedURL, resultType: WindSpeedInfoData.self) { windowSpeedInfoResult in
            
            print("@@@@WINDSPEED")
         //   self.dispatchGroup.leave()
            
            var windSpeedReading = 0.0
            
            if windowSpeedInfoResult.windSpeedMetadata.windSpeedStations.count != 0 {
                
                for windSpeedData in windowSpeedInfoResult.windSpeedMetadata.windSpeedStations {

                    if windowSpeedInfoResult.windSpeedItems.count != 0 {
                        
                        for forecast in windowSpeedInfoResult.windSpeedItems {
                            
                            if forecast.windSpeedReadings.count != 0 {
                                
                                for forecastItem in forecast.windSpeedReadings {
                                    
                                    if windSpeedData.locationId == forecastItem.stationID {
                                        
                                        windSpeedReading = forecastItem.windSpeedValue
                                    }
                                }
                            }
                        }
                    }
                    let updatedWindSpeedInfo = UpdatedWindSpeedValueInfoData(name: windSpeedData.locationName, lattitude: windSpeedData.windSpeedLocation.latitude, longitude: windSpeedData.windSpeedLocation.longitude, windSpeedTemp: windSpeedReading)
                    self.windSpeedForecastDict.append(updatedWindSpeedInfo)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if(self.isWindSpeedClicked) {
                        self.stopLoader(loader: self.activityLoader)
                        self.navigateToForecastMap()
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }
    
    func getApiForTrafficImages() {
        
        guard let selectedText = selectedDateTimeTextField.text else {return}
        let requestParameterStr =  constructApiUrlLink(selectedText, isDateTimeOnly: true)
        let urlString = "\(AppConstant.trafficImageBaseUrl)\(ApiEndpoints.trafficImages.rawValue)?\(requestParameterStr)"
        let trafficImageURL = URL(string: urlString)!
        print(urlString)
        
        apiService.getApiData(requestURL: trafficImageURL, resultType: TrafficImageInfoData.self) { trafficImageResult in
            
            print("@@@@TRAFFIC")
                //  self.dispatchGroup.leave()
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                print("INSIDE")
                self.stopLoader(loader: self.activityLoader)
                if (self.isTrafficImageClicked) {
                    self.navigateToForecastMap()
                } else {
                   self.navigateToMapVC()
                }
            }

            if trafficImageResult.trafficImageItems.count != 0 {
                
                for trafficImageInfo in trafficImageResult.trafficImageItems {
                    
                    for cameraInfo in trafficImageInfo.cameras {
                                
                        let trafficImageUpdatedInfo = UpdatedTrafficImageInfoData(lattitude: cameraInfo.location.latitude, longitude: cameraInfo.location.longitude, trafficImgUrl: cameraInfo.image)
                        self.trafficImagesWithInfoDict.append(trafficImageUpdatedInfo)
                    }
                }
            } else {
                self.showEmptyResultAlert()
            }
        }
    }
    
    func constructApiUrlLink(_ dateTime: String, isDateTimeOnly: Bool) -> String {
        print(dateTime)
        
        let dateTimeArr:[String] = dateTime.components(separatedBy: " ")
        let selectedDate = dateTimeArr[0]
        print(selectedDate)
        let selectedTime = dateTimeArr[1]
        print(selectedTime)
        let hourMinuteArr:[String] = selectedTime.components(separatedBy: ":")
        let selectedHour = hourMinuteArr[0]
        print(selectedHour)
        let selectedMinute = hourMinuteArr[1]
        print(selectedMinute)
        
        // date_time=2023-02-01T09%3A00%3A00&date=2023-02-01
        var paramStr = ""
        if !isDateTimeOnly {
            paramStr = "date_time=\(selectedDate)T\(selectedHour)%3A\(selectedMinute)%3A00&date=\(selectedDate)"
            print(paramStr)
        } else {
            paramStr = "date_time=\(selectedDate)T\(selectedHour)%3A\(selectedMinute)%3A00"
            print(paramStr)
        }
        
        return paramStr
    }
    
  
    //MARK: Navigation Method
    func navigateToMapVC() {
        print("NAV")
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.updatedWeatherDict = weatherUpdateDict
        mapVC.updatedAirTempDict = airTempDict
        mapVC.updatedRainForecastDict = rainForecastDict
        mapVC.updatedRelativeHumidityForecatDict = relativeHumidityForecatDict
        mapVC.updatedWindDirectionForecastDict = windDirectionForecastDict
        mapVC.updatedWindSpeedForecastDict = windSpeedForecastDict
        mapVC.updatedTrafficImagesWithInfoDict = trafficImagesWithInfoDict
        selectedDateTimeTextField.text = ""
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func navigateToForecastMap() {
        print(" Forecast NAV")
            let forecastMapVC = self.storyboard?.instantiateViewController(withIdentifier: "ForecastMapViewController") as! ForecastMapViewController
        
            forecastMapVC.updatedTwoHourWeatherDict = weatherUpdateDict
            forecastMapVC.isTwoDayForecast = isTwoDayForecastClicked
            forecastMapVC.updatedAirTempDict = airTempDict
            forecastMapVC.isAirTemp = isAirTempClicked
            forecastMapVC.updatedRainForecastDict = rainForecastDict
            forecastMapVC.isRainTemp = isRainTempClicked
            forecastMapVC.updatedRelativeHumidityForecatDict = relativeHumidityForecatDict
            forecastMapVC.isHumidityTemp = isHumidityTempClicked
            forecastMapVC.updatedWindDirectionForecastDict = windDirectionForecastDict
            forecastMapVC.isWindDirection = isWindDirectionClicked
            forecastMapVC.updatedWindSpeedForecastDict = windSpeedForecastDict
            forecastMapVC.isWindSpeed = isWindSpeedClicked
            forecastMapVC.updatedTrafficImagesWithInfoDict = trafficImagesWithInfoDict
            forecastMapVC.isTrafficImage = isTrafficImageClicked
            self.selectedDateTimeTextField.text = ""
            self.navigationController?.pushViewController(forecastMapVC, animated: true)
        
    }
   
    //MARK: Button Actions
    
    @IBAction func checkWeatherButtonClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {

            activityLoader = self.loader()
            getApiDataForTwoHourWeatherForecast()
            getApiForAirTemperatureInfo()
            getApiForRainfallInfo()
            getApiForRelativeHumidityInfo()
            getApiForWindDirection()
            getApiForWindSpeed()
            getApiForTrafficImages()

        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func windSpeedButtonClicked(_ sender: Any) {
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isWindSpeedClicked = true
            getApiForWindSpeed()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    
    @IBAction func twoDayForcastClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isTwoDayForecastClicked = true
            getApiDataForTwoHourWeatherForecast()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func trafficButtonClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isTrafficImageClicked = true
            getApiForTrafficImages()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func windDirectionButtonClicked(_ sender: Any) {
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isWindDirectionClicked = true
            getApiForWindDirection()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func humidityButtonClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isHumidityTempClicked = true
            getApiForRelativeHumidityInfo()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func rainfallButtonClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isRainTempClicked = true
            getApiForRainfallInfo()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    @IBAction func airTempButtonClicked(_ sender: Any) {
        
        if let selectedTextFieldVal = selectedDateTimeTextField.text, !selectedTextFieldVal.isEmpty {
            
            activityLoader = self.loader()
            isAirTempClicked = true
            getApiForAirTemperatureInfo()
        } else {
            showNoDateSelectAlert()
            return
        }
    }
    
    func showEmptyResultAlert() {
        
        let dismissAlert = UIAlertController(title: "Weather Update", message: "No Data Found", preferredStyle: UIAlertController.Style.alert)

        dismissAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
             //print("Handle Cancel Logic here")
            self.clearData()
          }))
        present(dismissAlert, animated: true, completion: nil)
    }
    
    func showNoDateSelectAlert() {
        
        let showAlert = UIAlertController(title: "Weather Update", message: "Please select Date", preferredStyle: UIAlertController.Style.alert)

        showAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
             //print("Handle Cancel Logic here")
            self.clearData()
          }))
        present(showAlert, animated: true, completion: nil)
    }
    
    func clearData() {
        selectedDateTimeTextField.text = ""
        isAirTempClicked = false
        isRainTempClicked = false
        isHumidityTempClicked = false
        isWindDirectionClicked = false
        isWindSpeedClicked = false
        isTrafficImageClicked = false
        isTwoDayForecastClicked = false
    }
}

extension InitialViewController: UITextFieldDelegate {
    
    //TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return false
    }
    
    func createToolbar() -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonClicked))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    func createDateTimePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        selectedDateTimeTextField.inputView = datePicker
        selectedDateTimeTextField.inputAccessoryView = createToolbar()
    }
    

    @objc func doneButtonClicked() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        self.selectedDateTimeTextField.text = dateFormatter.string(from: datePicker.date)
        self.selectedDateTimeTextField.textAlignment = .center
        
        self.view.endEditing(true)
    }
}


