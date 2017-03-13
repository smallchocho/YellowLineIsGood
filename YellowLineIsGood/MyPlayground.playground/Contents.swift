//: Playground - noun: a place where people can play

//import UIKit
//import CoreLocation
//import SwiftyJSON
//import PlaygroundSupport
//
//PlaygroundPage.current.needsIndefiniteExecution = true
//func getPolyline()-> String{
//    let googleDirectionKey = "AIzaSyD6LoSBok2GeFIJZQbkNjFfwj7kIifkGhc"
//    let origin = "台北市中正區南海路51號"
//    let destination = "台北市中正區南海路53號"
//    var urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(googleDirectionKey)"
//    print(urlString)
//    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//    print(urlString)
//    let url = URL(string: urlString)
//    var polylineString = ""
//    let getting = URLSession.shared.dataTask(with: url!, completionHandler: {
//        (data:Data?,response:URLResponse?,error:Error?) in
//        if error != nil{
//            return
//        }
//        if let jsonData = data{
//            let okJsonData = JSON(data:jsonData)
//            polylineString = okJsonData["routes"][0]["overview_polyline"]["points"].stringValue
//        }
//        print(polylineString)
//    })
//    getting.resume()
//    return polylineString
//}
