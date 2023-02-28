//
//  MarkerWindow.swift
//  WeatherUpdateSingapore
//
//  Created by Capgemini-DA184 on 2/27/23.
//

import UIKit

class MarkerWindow: UIView {

    @IBOutlet weak var TwoDayWeatherFprecastLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var relativeHumidityLabel: UILabel!
    @IBOutlet weak var RainfallLabel: UILabel!
    @IBOutlet weak var airTemperatureLabel: UILabel!
    @IBOutlet weak var trafficImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarkerWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
