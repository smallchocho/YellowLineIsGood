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
class GoogleMapDirection{
    //    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    //    var selectedRoute: Dictionary<String, String>!
    //    var overviewPolyline: Dictionary<String, String>!
    //    var originCoordinate: CLLocationCoordinate2D!
    //    var destinationCoordinate: CLLocationCoordinate2D!
    //    var originAddress: String!
    //    var destinationAddress: String!
    static func getPolyline() ->String{
        let googleDirectionKey = "AIzaSyD6LoSBok2GeFIJZQbkNjFfwj7kIifkGhc"
        let origin = "台北市中正區南海路51號"
        let destination = "台北市中正區南海路53號"
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
                let okJsonData = JSON(data:jsonData)
                polylineString = okJsonData["routes"][0]["overview_polyline"]["points"].stringValue
                print(polylineString)
            }
            
        })
        getting.resume()
        return polylineString
    }
    

}


