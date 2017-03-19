//: Playground - noun: a place where people can play

import UIKit
import CoreLocation
import SwiftyJSON
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//func getSearchResult()-> [String:[[String:Any]]]{
////    https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=25.039948,121.534417&radius=25000&name=%E5%8F%B0%E5%8C%97%E5%B8%82%E6%94%BF%E5%BA%9C&key=AIzaSyBxyl5w_mkn8oggbLsrZpKRhy9FUcGaVMQ
    let googleDirectionKey = "AIzaSyBxyl5w_mkn8oggbLsrZpKRhy9FUcGaVMQ"
    let locationLatitude = 25.039948
    let locationLongitude = 121.534417
    let radius = 25000
    let name = ""
    let keyWord = "總統府"
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationLatitude),\(locationLongitude)&radius=\(radius)&name=\(name)&keyword=\(keyWord)&key=\(googleDirectionKey)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let url = URL(string: urlString)
let request = URLRequest(url: url!)






//    var searchResults:[String:[[String:Any]]] = [
//        "result":[
//            [:]
//        ]
//    ]
//    let getting = URLSession.shared.dataTask(with: url!, completionHandler: {
//        (data:Data?,response:URLResponse?,error:Error?) in
//        if error != nil{
//            return
//        }
//        if let jsonData = data{
//            let okJsonData = JSON(data:jsonData)
//            let resultCount = okJsonData["results"].count
//            print("搜尋結果有\(resultCount)項")
//            
//            for i in 0...(resultCount-1){
//                var searchResult:[String:Any] =
//                    [
//                        "name":"",
//                        "address":"",
//                        "latitude":0,
//                        "longitude":0
//                    ]
//                searchResult["name"] = okJsonData["results"][i]["name"].stringValue
//                searchResult["address"] = okJsonData["results"][i]["vicinity"].stringValue
//                searchResult["latitude"] = okJsonData["results"][i]["geometry"]["location"]["lat"].float
//                searchResult["longitude"] = okJsonData["results"][i]["geometry"]["location"]["lng"].float
//                searchResults["result"]?.append(searchResult)
//            }
//            
//        }
//        
//        print(searchResults)
//    })
//    getting.resume()
//    return searchResults
//}

