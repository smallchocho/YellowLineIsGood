//
//  GoogleMapDirection.swift
//  YellowLineIsGood
//
//  Created by Justin Huang on 2017/3/6.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//
//
import Foundation
import CoreLocation
import SwiftyJSON
import GoogleMaps
class GoogleMapDirectionPolyline{
    var polyline = GMSPolyline()
    func drawYellowLine(mapView:GMSMapView,origin:String,destination:String){
        let googleDirectionKey = "AIzaSyD6LoSBok2GeFIJZQbkNjFfwj7kIifkGhc"
        var urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(googleDirectionKey)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)
        var polylineString = ""
        let getting = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data:Data?,response:URLResponse?,error:Error?) in
            if error != nil{
                return
            }
            if let jsonData = data{
                DispatchQueue.main.async {
                    let okJsonData = JSON(data:jsonData)
                    polylineString = okJsonData["routes"][0]["overview_polyline"]["points"].stringValue
                    let path = GMSMutablePath(fromEncodedPath: polylineString)
                    self.polyline = GMSPolyline(path: path)
                    self.polyline.map = mapView
                    self.polyline.strokeWidth = 13
                    self.polyline.strokeColor = UIColor(colorLiteralRed: 255/255, green: 209/255, blue: 25/255, alpha: 1.0)
                }
            }
        })
        getting.resume()
    }
    func removeYellowLine(){
        self.polyline.map = nil
        self.polyline.path = GMSPath(fromEncodedPath: "")
    }
}


