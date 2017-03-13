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
import SwiftyJSON

class MapViewController: UIViewController{
    //from Storyboard
    
    //Map Marker
    @IBOutlet weak var marker: UIView!
    @IBOutlet weak var markerLabel: UILabel!
    //Marker Info Window
    @IBOutlet weak var yellowLineMarkerSnippet: UIView!
    @IBOutlet weak var yellowLineMarkerTitle: UILabel!
    @IBOutlet weak var yellowLineMarkerFreeTime: UILabel!
    @IBOutlet weak var yellowLineMarkerfreeStatus: UILabel!
    @IBOutlet weak var triangleView: UIView!
    //Marker Info Window Button
    @IBAction func checkYellowLine(_ sender: UIButton) {
        if tapMarker != nil{
            yellowLineMarkerSnippet.removeFromSuperview()
            changeCameraPositionForMarker(mapView: self.mapView, marker: tapMarker,distanceFromMarker:0,zoom:19.0)
        }
        let origin = (tapMarker.userData as! [String:Any])["startPoint"] as! String
        let destination = (tapMarker.userData as! [String:Any])["endPoint"] as! String
        //畫出黃線
        polylineOfYellowLine.drawYellowLine(mapView: self.mapView,origin: origin, destination: destination)
        
    }
    @IBAction func navigateToYellowLine(_ sender: UIButton) {
        if tapMarker != nil{
            openGmap(location: tapMarker.position, zoom: 12)
        }
    }
    @IBAction func showNowLoccation(_ sender: UIButton) {
        print("點現在位置")
        locationManager.startUpdatingLocation()
        yellowLineMarkerSnippet.removeFromSuperview()
    }
    var isFirstLoading = true
    var mapView:GMSMapView!
    var locationManager = CLLocationManager()
    var polylineOfYellowLine = GoogleMapDirectionPolyline()
    var drawView = DrawSpecificView()
    var tapMarker:GMSMarker!
    var yellowlineData = YellowLineData().data
    
    
    @IBAction func goToSearchResult(_ sender: UIButton) {
        performSegue(withIdentifier: "presentSeachTableView", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定locationManager的delegate
        locationManager.delegate = self
        drawView.drawTriangle(superView: self.triangleView, fillCgColor: UIColor(colorLiteralRed: 255/255, green: 199/255, blue: 31/255, alpha: 1).cgColor)
        //設定MapView並加入SuperView
        setUpMapView()
        //設定mapview的delegate
        mapView.delegate = self
        //更新目前位置
        locationManager.startUpdatingLocation()
        //生成MapMarker
        creatMapMarker(insertMapView: self.mapView)
    }
    override func viewDidAppear(_ animated: Bool) {
        //提醒視窗
        if isFirstLoading == false{
            return
        }
        isFirstLoading = false
        presentAlert(alertTitle: "黃線好停車", alertMessage: "黃線好停車目前只提供假日可免費不限時停車地點，但是政府政策可能會轉彎，亦請車主至現場停車時以現場告示牌為準", actionTitle: "好的，知道了", actionHandler: nil)
    }
    //也可以用Gmap的Delegate在一開始時顯示目前位置
    //    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    //        let location = mapView.myLocation
    //        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
    //        mapView.animate(to: camera)
    //    }
}
// MARK:CLLocationManagerDelegate
extension MapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
}
// MARK:GMSMaperDelegate
extension MapViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture == true{
//            yellowLineMarkerSnippet.removeFromSuperview()
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        yellowLineMarkerSnippet.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //每次點擊marker時,就更新到tapMarker，這樣能夠在其他地方調用目前點擊的Marker相關資訊
        tapMarker = marker
        //依照點到的Marker去更新camera
        changeCameraPositionForMarker(mapView: mapView, marker: marker, distanceFromMarker:80 , zoom: nil)
        //設定makerInfoWindow並加入mapView
        addInfoWindowOfMarker(mapView: mapView, marker: marker)
        //清除已經顯示的黃線
        polylineOfYellowLine.removeYellowLine()
        return true
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        /*每次camera發生變化時，檢查tapMarker有沒有存入marker資料，
        如果有，則計算該marker座標映射到mapView的View座標，
        並用此座標更新yellowLineMarkerSnippet.center*/
        if tapMarker != nil{
            var viewPoint = mapView.projection.point(for: tapMarker.position)
            viewPoint.y -= yellowLineMarkerSnippet.frame.height/1.25
            yellowLineMarkerSnippet.center = viewPoint
        }
    }
}

// MARK:UI相關方法
extension MapViewController{
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
            let holidayFree = self.yellowlineData["yellowLine"]?[i]["holidayFree"] as! Bool
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
                if self.checkYellowLineIsAvailableNow(nowDate: Date(), holidayFree: holidayFree){
                    self.markerLabel.text = "免"
                }else{
                    self.markerLabel.text = "X"
                }
                markerLocation = location.coordinate
                marker.position = markerLocation
                self.marker.frame = CGRect(x: 0.0, y: 0.0, width:UIScreen.main.bounds.width/8, height: UIScreen.main.bounds.width/8)
                marker.iconView = self.marker
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = insertMapView
                marker.userData = self.yellowlineData["yellowLine"]?[i]
            }
        }
    }
    //對客製化InfoWindow設定後並加入mapView
    func addInfoWindowOfMarker(mapView:GMSMapView,marker:GMSMarker){
        //設定InfoWindow的內容顯示
        yellowLineMarkerTitle.text = (marker.userData as! [String:Any])["title"] as? String
        yellowLineMarkerFreeTime.text = (marker.userData as! [String:Any])["freeTime"] as? String
        let holidayFree = (marker.userData as! [String:Any])["holidayFree"] as? Bool
        if self.checkYellowLineIsAvailableNow(nowDate: Date(), holidayFree: holidayFree!){
            self.yellowLineMarkerfreeStatus.text = "現在免費中"
        }else{
            self.yellowLineMarkerfreeStatus.text = "現在禁止停車"
        }
        //把InfoWindow加入mapView
        self.mapView.addSubview(yellowLineMarkerSnippet)
        //抓取marker的目前位置並映射到mapView的座標
        var viewPoint = mapView.projection.point(for: marker.position)
        //將mapView的座標往上調整後
        viewPoint.y -= yellowLineMarkerSnippet.frame.height/1.25
        //調整InfoWindow的center
        yellowLineMarkerSnippet.center = viewPoint
    }
    //依照Marker更新camera
    func changeCameraPositionForMarker(mapView:GMSMapView,marker:GMSMarker,distanceFromMarker:CGFloat = 0,zoom:Float?){
        var markerPoint = mapView.projection.point(for: marker.position)
        markerPoint.y -= distanceFromMarker
        var inputZoom = mapView.camera.zoom
        if zoom != nil{
            inputZoom = zoom!
        }
        let changePosition = mapView.projection.coordinate(for: markerPoint)
        let camera = GMSCameraPosition.camera(withLatitude: changePosition.latitude, longitude: changePosition.longitude, zoom: inputZoom)
        mapView.animate(to: camera)
    }
    //Alert
    func presentAlert(alertTitle:String?,alertMessage:String?,actionTitle:String?,actionHandler:((UIAlertAction)->Void)?){
        let errorAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: actionHandler)
        errorAlert.addAction(defaultAction)
        present(errorAlert, animated: true, completion: nil)
    }
    //確認現在時間是否可停車
    func checkYellowLineIsAvailableNow(nowDate:Date,holidayFree:Bool)->Bool{
        let nowWeekDay = DateManager.nowWeekDay(date: Date())
        let nowHour = DateManager.nowHour(date: Date())
//        let nowHour = 10
        if holidayFree == true{
            switch nowWeekDay{
            case 0:
                return true
            case 7:
                return true
            default:
                if nowHour >= 20 || nowHour < 7{
                    return true
                }else{
                    return false
                }
            }
        }else{
            if nowHour >= 20 || nowHour < 7{
                return true
            }else{
                return false
            }
        }
    }
}
extension MapViewController{
    //打開GoogleMap應用程式或用Safari開啟GoogleMap網站
    func openGmap(location:CLLocationCoordinate2D,zoom:Int){
        let safariUrl = URL(string: "https://maps.google.com/?q=\(location.latitude),\(location.longitude)&mapmode=standard&center=\(location.latitude),\(location.longitude)&zoom=\(zoom)")
        
        let GmapAppUrl = URL(string: "comgooglemaps://?q=\(location.latitude),\(location.longitude)&mapmode=standard&center=\(location.latitude),\(location.longitude)&zoom=\(zoom)")
        //ios10以上執行的方法
        if #available(iOS 10, *){
            //在iOS10以後open方法裡頭可回傳開啟Url是否成功的Bool，藉以取代舊版本的canOpenURL的方法
            UIApplication.shared.open(GmapAppUrl!, options: [:], completionHandler: { (bool:Bool) in
                guard bool else{
                    //如果沒有安裝GMapApp就打開普通GMap網址
                    UIApplication.shared.open(safariUrl!, options: [:], completionHandler: nil)
                    return
                }
            })
            //ios9以下的執行方法
        }else{
            if UIApplication.shared.canOpenURL(GmapAppUrl!){
                UIApplication.shared.openURL(GmapAppUrl!)
            }else{
                UIApplication.shared.openURL(safariUrl!)
            }
        }
    }
    
}






