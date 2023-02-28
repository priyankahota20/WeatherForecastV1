//
//  TrafficMarkerWindow.swift
//  WeatherUpdateSingaptrafficMarkerWindowore
//
//  Created by Capgemini-DA184 on 2/28/23.
//

import UIKit

class TrafficMarkerWindow: UIView {

    @IBOutlet weak var trafficImageView: UIImageView!

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TrafficMarkerWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

}
