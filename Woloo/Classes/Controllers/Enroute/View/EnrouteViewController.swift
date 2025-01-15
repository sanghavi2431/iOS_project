//
//  EnrouteViewController.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class EnrouteViewController: UIViewController,GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var vwMap: MapContainerView!
    @IBOutlet weak var vwBackCurrentLocation: UIView!
    @IBOutlet weak var vwBackDestinationLocation: UIView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnHostLocation: UIButton!
    @IBOutlet weak var txtFieldCurrentLocation: UITextField!
    @IBOutlet weak var txtFieldDestinationLocation: UITextField!
    @IBOutlet weak var vwBottomBack: UIView!
    
    //@IBOutlet weak var btnStartNavigation: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var mapDirectionPopUpView: UIView!
    
    var strSource_Destination: String? = ""
    var sourceLat, sourceLong : Double?
    var destLat, destLong : Double?
    var sourceAddress, destAddress : String?
    var strCurrAddress: String = ""
    var hasStartedRouting : Bool = false
    var isFetchingPath : Bool = false
    var nearByStoreResponseDOV2 = [NearbyResultsModel]()
    var allStoresListv2 = [NearbyResultsModel]()
    var bottomPopViewPolyline: [String : Any] = [:]
    var googleToken: GMSAutocompleteSessionToken?
    
    var strIsComeFrom: String? = ""
    var strDestination: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        DELEGATE.rootVC?.tabBarVc?.hideFloatingButton()
        self.vwBackCurrentLocation.layer.cornerRadius = 10
        self.vwBackDestinationLocation.layer.cornerRadius = 10
        tabBarController?.tabBar.isHidden = true
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        if let currentLocation = DELEGATE.locationManager.location {
            vwMap.currentPosition = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
            self.reverseGeocodeCoordinate(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            
            self.sourceLat = currentLocation.coordinate.latitude
            self.sourceLong = currentLocation.coordinate.longitude
        }
        
        if self.strIsComeFrom == "Navigation"{
            self.txtFieldDestinationLocation.text = self.strDestination
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        }
        
        vwMap.delegate = self
        vwMap.configureUI()
        vwMap.animate(toZoom: 14)
        vwMap.isMyLocationEnabled = true
        vwMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.vwBottomBack.layer.cornerRadius = 25.0
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    //MARK: - Button Action Methods
    
    @IBAction func clickedBtnSourceLocation(_ sender: UIButton) {
        
        print("search source locations")
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        self.strSource_Destination = SELCTED_ENROUTE_TYPE.SOURCE.rawValue
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @IBAction func clickedDestinationLocations(_ sender: UIButton) {
        print("search destination locations")
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        self.strSource_Destination = SELCTED_ENROUTE_TYPE.DESTINATION.rawValue
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @IBAction func popUpContinueBtnPressed(_ sender: Any) {
      
        if let googleMapsURL = URL(string: "comgooglemaps://"),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            
            let directionsURLString = "comgooglemaps://?saddr=\(sourceLat ?? 0),\(sourceLong ?? 0)&daddr=\(destLat ?? 0),\(destLong ?? 0)&directionsmode=driving"
            
            if let directionsURL = URL(string: directionsURLString) {
                UIApplication.shared.open(directionsURL, options: [:]) { success in
                    if success {
                        print("Google Maps opened successfully.")
                    } else {
                        print("Failed to open Google Maps.")
                    }
                }
            }
        } else {
            NSLog("Can't use comgooglemaps://")
        }

        
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        
        self.mapDirectionPopUpView.isHidden = true
    }
    
    
    @IBAction func clickedBackBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    @IBAction func clickedBtnStartNavigation(_ sender: UIButton) {
//        
//        self.mapDirectionPopUpView.isHidden = false
//    }
    
    
    func reverseGeocodeCoordinate(latitude: Double, longitude: Double) {
            let geocoder = GMSGeocoder()
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        geocoder.reverseGeocodeCoordinate(coordinate) { [self] (response, error) in
                if let error = error {
                    print("Error in reverse geocoding: \(error.localizedDescription)")
                    return
                }
                
                if let address = response?.firstResult(), let lines = address.lines {
                    // You can access various parts of the address here
                    let formattedAddress = lines.joined(separator: ", ")
                    print("Address: \(formattedAddress)")
                    strCurrAddress = formattedAddress
                    self.txtFieldCurrentLocation.text = strCurrAddress
                } else {
                    print("No address found")
                }
            }
        }
    
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("(\(source.latitude),\(source.longitude))->(\(destination.latitude),\(destination.longitude))")
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=0&key=AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4")!
       
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            if let routes = jsonResult["routes"] as? [Any] , routes.count > 0  {
                guard let route = routes[0] as? [String: Any]
                else {
                    return
                }
                
                
                if let legs = route["legs"] as? [Any] , legs.count > 0  {
                    DispatchQueue.main.async {
                        //self.stackDirection1.isHidden = true
                        //self.vwDirection2.isHidden = true
                    }
                    if let leg = legs[0] as? [String: Any] {
                        print("stepIn 1")
                        if let steps = leg ["steps"] as? [Any], steps.count > 0 {
                            print("stepIn 2")
                            if let step1 = steps[0] as? [String:Any] {
                                print("stepIn 3")
                                if let dist1 = step1["distance"] as? [String:Any] {
                                    print("stepIn 4")
                                    if let dist1Val = dist1["text"] as? String {
                                        print("stepIn 5")
                                        if steps.count == 1 {
                                            print("stepIn 6")
                                            if let dist = dist1["value"] as? Int, dist <= 50 {
                                                print("stepIn 7")
                                                //if let wid = self.storeId2! {
                                                    print("stepIn 8")
                                                    self.hasStartedRouting = false
                                               // self.wolooNavigationRewardAPI(wolooId: self.storeId2 ?? 0)
//                                                    self.vwScanQr.isHidden = false
                                                //}
                                            }
                                            else {
                                                print("stepOut 7")
                                            }
                                        } else {
                                            print("stepOut 6")
                                        }
                                        DispatchQueue.main.async {
                                            //self.lblDirection1.text = dist1Val
                                           // self.stackDirection1.isHidden = false
                                            if let maneuver1 = step1["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                   // self.imgDirection1.image = m1image
                                                } else {
                                                    //self.imgDirection1.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    } else {
                                        print("stepOut 5")
                                    }
                                }  else {
                                    print("stepOut 4")
                                }
                            }  else {
                                print("stepOut 3")
                            }
                            if steps.count > 1, let step2 = steps[1] as? [String:Any] {
                                if let dist2 = step2["distance"] as? [String:Any] {
                                    if let dist2Val = dist2["text"] as? String {
                                        DispatchQueue.main.async {
                                            //self.lblDirection2.text = dist2Val
                                            //self.vwDirection2.isHidden = false
                                            if let maneuver1 = step2["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                 //   self.imgDirection2.image = m1image
                                                } else {
                                                  //  self.imgDirection2.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("stepOut 2")
                        }
                        
                        DispatchQueue.main.async {
                            if let distance = leg["distance"] as? [String: Any] {
                               // self.lblKm.text = distance["text"] as? String ?? ""
                                
                                //self.distanceLbl.text = distance["text"] as? String ?? ""
                                self.lblDistance.text = distance["text"] as? String ?? ""
                                
                            }
                            if let distance = leg["duration"] as? [String: Any] {
                                //self.lblMins.text = distance["text"] as? String ?? ""
                                
                                //self.timeLbl.text = distance["text"] as? String ?? ""
                                self.lblTime.text = distance["text"] as? String ?? ""
                                
                            }
                        }
                    } else {
                        print("stepOut 1")
                    }
                    
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    
                    return
                }
                print("OverviewPolyline: \(overview_polyline)")
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.vwMap.clear()
                   self.vwMap.addDestinationMarker(lat: destination.latitude, long: destination.longitude, name: "Destination", index: 0)
                    self.destLat = destination.latitude
                    self.destLong = destination.longitude
                    
                    self.vwMap.addCurrentPositionMarker(currentPosition: source)
                    
                    let sourcePoint = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                    let destinationPoint = CLLocationCoordinate2D(latitude: source.latitude,longitude: source.longitude)
                let bounds = GMSCoordinateBounds(coordinate: sourcePoint, coordinate: destinationPoint)
                    
                    
                let mapInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
                self.vwMap.padding = mapInsets
                self.vwMap.animate(toZoom: 10)
                let camera = self.vwMap.camera(for: bounds, insets: UIEdgeInsets())!
                self.vwMap.camera = camera
                
                self.drawPath(from: polyLineString)
                self.isFetchingPath = false
                    
                   // if self.isDirection == false {
                        //self.getEnrouteWoloo(src_lat: source.latitude, src_lng: source.longitude, target_lat: destination.latitude, target_lng: destination.longitude, overview_polyline: overview_polyline)
                        
                        self.getEnrouteWoloo(src_lat: source.latitude, src_lng: source.longitude, target_lat: destination.latitude, target_lng: destination.longitude, overview_polyline: overview_polyline)
                        
                        self.bottomPopViewPolyline = overview_polyline
                        
                        //self.enrouteListTblView.reloadData()
                    //}
                    
                }
            }
        })
        task.resume()
        
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.map = self.vwMap
    }
    
    func getEnrouteWoloo(src_lat: Double, src_lng: Double, target_lat: Double, target_lng: Double, overview_polyline: [String : Any]){
        
        Global.showIndicator()
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        DELEGATE.locationManager.startUpdatingLocation()
        
        let data = ["src_lat": src_lat, "src_lng": src_lng, "target_lat": target_lat, "target_lng": target_lng, "overview_polyline": overview_polyline] as [String : Any]
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .enroute, method: .post, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("Enroute API response: ", response.results)
                
                
                //self.mapContainerView.addEnrouteMarkers
                self.vwMap.nearByStoreResponseDOV2 = response.results
                //                self.mapContainerView.addAllMarkersV2()
                self.nearByStoreResponseDOV2 = response.results
                self.allStoresListv2 = response.results
                
                
                self.vwMap.addEnrouteMarkers()
                // self.enrouteListTblHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
               // self.enrouteListTblView.reloadData()
             //   self.collectionView.reloadData()
                // mapContainerView.addEnrouteMarkers
                
            case .failure(let error):
                Global.hideIndicator()
                print("Enroute API failed: ", error)
            }
        }
    }
    
    
}
