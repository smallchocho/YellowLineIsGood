//
//  ViewController.swift
//  YellowLineIsGood
//
//  Created by Justin Huang on 2017/2/18.
//  Copyright © 2017年 Justin Huang. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    @IBOutlet var yellowLineMarkerSnippet: UIView!
    @IBOutlet weak var triangleView: UIView!
    @IBAction func showNowLoccation(_ sender: UIButton) {
        
        print("點現在位置")
        locationManager.startUpdatingLocation()
    }
    var mapView:GMSMapView!
    var locationManager = CLLocationManager()
    var polylineOfYellowLine:GMSPolyline?
    var drawView = DrawSpecificView()
    var tapMarker:GMSMarker!
    var yellowlineData =
        ["yellowLine":
            [
                [
                    "title":"興隆路",
                    "startPoint":"台北市文山區興隆路4段6-6號",
                    "endPoint":"台北市文山區興隆路4段6-6號",
                    "freeTime":"例假日全天免費",
                    "holidayFree":true,
                    ],
                [
                    "title":"我家",
                    "startPoint":"台北市文山區福興路78巷1弄20之1號",
                    "endPoint":"台北市文山區興隆路4段6-6號",
                    "freeTime":"例假日全天免費",
                    "holidayFree":true,
                    ],
                [
                    "title":"南海路",
                    "startPoint":"台北市中正區南海路51號",
                    "endPoint":"台北市中正區南海路53號",
                    "freeTime":"例假日全天免費",
                    "holidayFree":true,
                    ],
            ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定locationManager的delegate
        locationManager.delegate = self
        drawView.drawTriangle(superView: self.triangleView, fillCgColor: UIColor(colorLiteralRed: 197/255, green: 227/255, blue: 247/255, alpha: 1).cgColor)
        //設定MapView並加入SuperView
        setUpMapView()
        //設定mapview的delegate
        mapView.delegate = self
        //更新目前位置
        locationManager.startUpdatingLocation()
        //生成MapMarker
        creatMapMarker(insertMapView: self.mapView)
//        polylineOfYellowLine = drawYellowLine(mapView: self.mapView)
        
        
        //Location Manager code to fetch current location
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //提醒視窗
        presentAlert(alertTitle: "黃線好停車", alertMessage: "黃線好停車目前只提供假日可免費不限時停車地點，但是政府政策可能跟白海豚一樣會轉彎，亦請車主至現場停車時以現場告示牌為準", actionTitle: "好的，知道了", actionHandler: nil)
    }
    
    //也可以用Gmap的Delegate在一開始時顯示目前位置
    //    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    //        let location = mapView.myLocation
    //        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
    //        mapView.animate(to: camera)
    //    }
    
    
    
    
}
extension MapViewController{
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    //Set up GMSmapView
    func setUpMapView(){
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width , height:self.view.frame.height)
        self.mapView = GMSMapView.map(withFrame: rect, camera: GMSCameraPosition.camera(withLatitude: 25.063977, longitude: 121.6515269, zoom: 10))
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        //加入mapView，設定AutoLayout跟調整圖層順序
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(self.mapView, at: 0)
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
    }
    //Create MapMarker
    func creatMapMarker(insertMapView:GMSMapView){
        let count = self.yellowlineData["yellowLine"]!.count
        for i in 0...count - 1{
            let address = self.yellowlineData["yellowLine"]?[i]["startPoint"] as! String
            print(address)
            let geocoder = CLGeocoder()
            let marker = GMSMarker()
            var markerLocation = CLLocationCoordinate2D()
            //用MapKit的方法來轉換地址成為CLLocationCoordinate2D座標格式
            geocoder.geocodeAddressString(address){
                (placeMarks:[CLPlacemark]?, error:Error?) in
                if error != nil{
                    print(error.debugDescription)
                    print("地址轉座標失敗")
                    return
                }
                guard let placeMark = placeMarks?.first else{
                    print("No menber in placeMark")
                    return
                }
                
                guard let location = placeMark.location else{
                    print("No location in placeMark")
                    return
                }
                print(location.coordinate)
                markerLocation = location.coordinate
                marker.position = markerLocation
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = insertMapView
            }
        }
    }
    //Draw Yellow line
    func drawYellowLine(mapView:GMSMapView)->GMSPolyline{
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(25.005669, 121.550803))
        path.add(CLLocationCoordinate2DMake(25.004522, 121.551050))
        path.add(CLLocationCoordinate2DMake(25.004255, 121.549886))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        return polyline
    }
    //Present 
    func presentAlert(alertTitle:String?,alertMessage:String?,actionTitle:String?,actionHandler:((UIAlertAction)->Void)?){
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: actionHandler)
        errorAlert.addAction(defaultAction)
        present(errorAlert, animated: true, completion: nil)
    }
}
extension MapViewController{
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture == true{
            yellowLineMarkerSnippet.removeFromSuperview()
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        yellowLineMarkerSnippet.removeFromSuperview()
        print("按其他地方")
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tapMarker = marker
        
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude+0.006, longitude: marker.position.longitude, zoom: self.mapView.camera.zoom)
        mapView.animate(to: camera)
        yellowLineMarkerSnippet.removeFromSuperview()
        self.view.addSubview(yellowLineMarkerSnippet)
        var viewPoint = mapView.projection.point(for: tapMarker.position)
        viewPoint.y -= yellowLineMarkerSnippet.frame.height/1.25
        yellowLineMarkerSnippet.center = viewPoint
//        yellowLineMarkerSnippet.center = mapView.projection.point(for: location)
        print("按Marker")
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if tapMarker != nil{
            var viewPoint = mapView.projection.point(for: tapMarker.position)
            viewPoint.y -= yellowLineMarkerSnippet.frame.height/1.25
            yellowLineMarkerSnippet.center = viewPoint
        }
        print("座標改變中...")
    }
}

