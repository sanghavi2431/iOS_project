//
//  TabBarController.swift
//  Woloo
//
//  Created by Ashish Khobragade on 22/12/20.
//

import UIKit
import SafariServices

class TabBarController: UITabBarController {
    private let popupView = WolooTabPopUp.instanceFromNib()
    private var isLocatorTapped = false
    private var previousIndex = 0
    var netcoreEvents = NetcoreEvents()
    var isPopUpVisible: Bool? = false

    private let floatingButton: UIButton = {
            let button = UIButton(type: .custom)
            button.backgroundColor = .white
            button.setImage(UIImage(named: "icon_arrow_up"), for: .normal)
            button.tintColor = .white
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            //button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
           // button.layer.shadowOffset = CGSize(width: 0, height: 5)
            button.layer.shadowRadius = 5
            return button
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        DELEGATE.rootVC?.tabBarVc = self
        self.delegate = self
//        if let items = self.tabBar.items {
//            print("tab - \(self.tabBar.items?.first?.title ?? "12")")
//            let tabBarItem = items[2]
//            tabBarItem.image = UIImage(named: "icon_arrow_up")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//            tabBarItem.selectedImage = UIImage(named: "icon_arrow_up")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//            tabBarItem.title = ""
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom:25, right: 0)
//            } else {
//                tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom:25, right: 0)
//            }
//        }
        
        // Navigate to Loo Locate (Map View) Page
        self.selectedIndex = 2
        // Navigate to Home Page
        // self.selectedIndex = 0
        setupFloatingButton()
        setupPopupView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingButton.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        floatingButton.isHidden = true
    }
    
    private func setupFloatingButton() {
            view.addSubview(floatingButton)
            floatingButton.translatesAutoresizingMaskIntoConstraints = false

            // Constraints for the floating button
            NSLayoutConstraint.activate([
                floatingButton.widthAnchor.constraint(equalToConstant: 44),
                floatingButton.heightAnchor.constraint(equalToConstant: 40),
                floatingButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
                floatingButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 10)
            ])

            // Add action to button
            floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        }

    @objc private func floatingButtonTapped() {
            print("Floating button tapped")
            // self.showPopUpVC(vc: self)
            // Perform your custom action here, e.g., navigate to a specific view controller
        if popupView.frame.origin.y == view.frame.height {
                    showPopup()
                } else {
                    hidePopup()
                }
        }
    
    @objc private func dismissButtonTapped() {
            print("Dismiss button tapped")
     
        }
    
     func hideFloatingButton() {
          floatingButton.isHidden = true
      }

       func showFloatingButton() {
          floatingButton.isHidden = false
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private Methods
    
    func hideTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height + (frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBar.frame = frame
        })
    }

    func showTabBar() {
        var frame = self.tabBar.frame
        frame.origin.y = self.view.frame.size.height - (frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBar.frame = frame
        })
    }
    private func setupPopupView() {
            guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }

            keyWindow.addSubview(popupView)
            popupView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 400)

        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
       // self.popupView.btnDismiss.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        

       }

    
    private func showPopup() {
           UIView.animate(withDuration: 0.3) {
               self.popupView.frame.origin.y = self.view.frame.height - 400
               self.hideFloatingButton()
//               self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 390)
           
           }
        
       
       }

       private func hidePopup() {
           UIView.animate(withDuration: 0.3) {
               self.popupView.frame.origin.y = self.view.frame.height
               self.showFloatingButton()
           }
       }

    private func handleDismissPopUpView(tag: Int){
        switch tag {
        case 0:
            self.hidePopup()
            
        default:
            break
        }
    }
    
    
    func showPopUpVC(vc: UIViewController) {
           self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 390)
        popupView.handleDismissAction = {
            tag in
            switch tag {
            case 0:
                self.hidePopup()
                
            default:
                break
            }
            
        }
        
           popupView.handleButtonAction = { tag in
               switch tag {
               case 0:  // Shop-blogs
                   print("open shop/blogs from dashboard")
                   self.selectedIndex = 0
                   self.showFloatingButton()
               case 1: // shop
                   print("open shop ")
                   self.selectedIndex = 1
//                   self.openShopeVC()
//                   self.showFloatingButton()
                   break
               case 2: // Period Tracker
                  // self.getPeriodTracker()
                   print("open loo locator ")
                   self.selectedIndex = 2
                   self.showFloatingButton()
               case 3: // Expand And collapse
                   print("open Profile")
                   self.selectedIndex = 3
                   self.showFloatingButton()
               case 4: // period tracker"
                   print("open period tracker")
                   self.openTrackerVC()
               case 5: // thirst reminder
                   print("open thirst reminder")
                   self.openThirstReminder()
               case 6: // Woloo Community
                   print("open community")
                   self.openWolooCommunity()
               case 7: // Woloo blogs
                   print("open Blogs")
               default:
                   break
               }
           }
           vc.view.addSubview(popupView)
           
       }
}
extension TabBarController: UITabBarControllerDelegate {
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch selectedIndex {
                case 0: // First tab
            self.showFloatingButton()
                case 1: // Second tab
            self.showFloatingButton()
                case 2: // Third tab
            self.showFloatingButton()
                default: // Other tabs
            self.showFloatingButton()
                }
//        let rootView = self.viewControllers![self.previousIndex] as! UINavigationController
//        rootView.popToRootViewController(animated: false)
//        if self.selectedIndex == 2 { // Woloo Log clicked then show pop up
//            self.selectedIndex = previousIndex // forcely stop to changing tab.
//            UIView.animate(withDuration: 0.5, animations: {
//                //show popoup view
//                if self.isPopUpVisible == false{
//                    //show popoup
//                    self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-400, width: UIScreen.main.bounds.width, height: 400)
//                    self.isPopUpVisible = true
//                }
//                else{
//                    //hide popup
//                    self.popupView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 400)
//                    self.isPopUpVisible = false
//                }
//               
//            })
//        } else {
//            self.isPopUpVisible = false
//            previousIndex = self.selectedIndex
//        }
//        
//        print("myindex - \(self.selectedIndex)")
//        UserDefaults.standard.set(1, forKey:"overlay_shown")
//        UserDefaults.standard.synchronize()
    }
}

// MARK: - Handle Controllers
extension TabBarController {
    fileprivate func openShopeVC() {
        let vc = UIStoryboard.init(name: "Shop", bundle: Bundle.main).instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as? ECommerceDashboardViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

    fileprivate func openTrackerVC() {
            let vc = UIStoryboard.init(name: "Tracker", bundle: Bundle.main).instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController
            
            self.navigationController?.pushViewController(vc!, animated: true)
    
    }
    
    fileprivate func openThirstReminder() {
        let wolooDashboardSB = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        if let dashboardVC = wolooDashboardSB.instantiateViewController(withIdentifier: "WolooDashBoardVC") as? WolooDashBoardVC {
            dashboardVC.isFromDashBoard = true
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(dashboardVC, animated: true)
        }
        self.selectedIndex = 0
    }
    
    fileprivate func openWolooCommunity() {
        guard let url = URL(string: "https://iamhere.app/community/women_hygiene_1624314543470") else {
            return
        }
        // Present SFSafariViewController
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    fileprivate func editCycleVC(_ info: UserTrackerInfo? = nil) {
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            editCycleVc.isEditScreen = false
            if let editCycleInfo = info {
                editCycleVc.selectedDate = editCycleInfo.periodDate?.toDate()
                editCycleVc.cycleLength = editCycleInfo.cycleLength ?? 28
                editCycleVc.periodLength = editCycleInfo.periodLength ?? 4
                editCycleVc.loginfo = editCycleInfo.log
            }
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(editCycleVc, animated: true)
        }
    }
    
    func openEditCycleVC(info: ViewPeriodTrackerModel?){
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            editCycleVc.isEditScreen = false
           // if let editCycleInfo = info {
            editCycleVc.selectedDate = info?.periodDate?.toDate() ?? Date()
            print("period date: ", info?.periodDate?.toDate() ?? Date())
                
            editCycleVc.cycleLength = info?.cycleLength ?? 28
            editCycleVc.periodLength = info?.periodLength ?? 4
            editCycleVc.loginfo = info?.log
         //   }
            let navigationVC = self.viewControllers![self.previousIndex] as! UINavigationController
            navigationVC.pushViewController(editCycleVc, animated: true)
        }
    }
}

// MARK: - API Calling
extension TabBarController {
    private func getPeriodTracker() {
           APIManager.shared.getPeriodTracker { [weak self] (trackerInfo, message) in
               guard let weak = self else { return }
               if let info = trackerInfo {
                   
                   if info.id == nil {
                       weak.editCycleVC(info)
                   } else if let date = info.periodDate?.toDate(), let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                       // date 35 days ago
                       let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                       if days < 0 {
                           weak.editCycleVC(info)
                           return
                       } else {
                           weak.openTrackerVC()
                           return
                       }
                   }
                   else {
                       weak.editCycleVC()
                       return
                   }
                   
                   print("period tracker info: \(info)")
                   //                print(info.toJSONString() ?? "")
                   Global.addNetcoreEvent(eventname: self!.netcoreEvents.periodTrackerUpdateClick, param: ["period_date":"\(info.periodDate)","cycle_length":"\(info.cycleLength)","period_length":"\(info.periodLength)","luteal_length":"\(info.lutealLength)", "user_id":"\(UserModel.user?.userId ?? 0)", "platform":"iOS"])
               }
               print(message)
           }
    }

    
    private func getPeriodTrackerV2(){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers, url: nil, service: .viewperiodtracker, method: .get, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("View period tracker: ", response.results)
                if response.results.id == nil{
                    
                    print("open edit cycle")
                    self.openEditCycleVC(info: response.results)
                }else if let date = response.results.periodDate?.toDate(), let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                    
                    let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                    if days < 0 {
                        print("open edit cycle")
                        self.openEditCycleVC(info: response.results)
                        return
                    } else {
                        self.openTrackerVC()
                        return
                    }
                }
                else {
                    print("open edit cycle")
                    self.openEditCycleVC(info: response.results)
                    return
                }
                
                
                
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("View periodTracker API failed: ", error)
            }
        }
    }
}

