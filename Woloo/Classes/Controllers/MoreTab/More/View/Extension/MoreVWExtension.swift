////
////  MoreVWExtension.swift
////  Woloo
////
////  Created by Kapil Dongre on 24/10/24.
////
//
import Foundation
import UIKit
import Smartech

extension MoreVC: UITableViewDelegate, UITableViewDataSource, DashboardViewModelDelegate, MoreViewModelDelegate{
    
    //MARK: - MoreViewModelDelegate
    
    
    func didReceiveUploadProfilePhotoResponse(objResponse: BaseResponse<Profile>) {
        Global.hideIndicator()
        self.objDashboardViewModel.getUserProfileAPI()
    }
    
    func didUploadProfilePhotoError(strError: String) {
        Global.hideIndicator()
    }
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        //
    }
    
    func didReceiceWahCertificateError(strError: String) {
        //
    }
    
   

    //MARK: - DashboardViewModelDelegate
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
        Global.hideIndicator()
        UserDefaultsManager.storeUserData(value: objResponse.results)
        if self.moreDetailV2 == nil {
            self.moreDetailV2 = MoreTabDetailV2()
        }
        objUser = objResponse.results
        self.moreDetailV2?.userData = objUser.profile
        self.moreDetailV2?.userCoin = objUser.totalCoins
        self.moreDetailV2?.subscriptionData = objUser.planData
        self.updateProfileData()
        
    }
    
    func didReceievGetUserProfileError(strError: String) {
        Global.hideIndicator()
    }
    
    
    
    func getProfile() {
        UserModel.apiMoreProfileDetails { (userModel) in
            DispatchQueue.main.async {
                if self.moreDetail == nil {
                    self.moreDetail = MoreTabDetail()
                }
                //                UserModel.saveAuthorizedUserInfo(userModel?.userData)
                self.moreDetail?.userData = userModel?.userData
                self.moreDetail?.userCoin = userModel?.totalCoins
                self.moreDetail?.subscriptionData = userModel?.planData
                self.updateProfileData()
            }
        }
    }
    
    //MARK: - UITableViewDelegate & UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2){
            
            return 10
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell: HeaderProfileCell? = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell") as! HeaderProfileCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("HeaderProfileCell", owner: self, options: nil)?.last as? HeaderProfileCell)
            }
            
           
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        else if indexPath.section == 1{
            var cell: UserProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell") as! UserProfileTableViewCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("UserProfileTableViewCell", owner: self, options: nil)?.last as? UserProfileTableViewCell)
            }
            
            cell?.editProfileClickEvent = { [weak self] () in
                guard let self = self else { return }
                
               // self.performSegue(withIdentifier: Segues.editProfile, sender: nil)
                let vc = (UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController)!
                vc.userDataV2 = self.objUser
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell?.editProfilePicClickEvent = { [weak self] () in
                guard let self = self else { return }
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
            
            cell?.openAccountClickEvent = { [weak self] () in
                guard let self = self else { return }
                
               // self.performSegue(withIdentifier: Segues.editProfile, sender: nil)
                let vc = (UIStoryboard.init(name: "MyAccount", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC)!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell?.configureUserProfileTableViewCell(objUser: self.moreDetailV2)
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        else{
            var cell: MenuItemsCell? = tableView.dequeueReusableCell(withIdentifier: "MenuItemsCell") as! MenuItemsCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("MenuItemsCell", owner: self, options: nil)?.last as? MenuItemsCell)
            }
            cell?.configureMenuItemsCell(currentIndexPath: indexPath)
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
        }
        else{
            
            if indexPath.row == 0{
                //Buy peer's club membership
                Global.addFirebaseEvent(eventName: "upgrade_click", param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
                
                Global.addNetcoreEvent(eventname: self.netcoreEvents.upgradeClick, param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
                
                self.performSegue(withIdentifier: "SubscriptionVC", sender: nil)
                
            }else if indexPath.row == 1{
                //Refer a friend
                let vc = UIStoryboard.init(name: "InviteFriend", bundle: Bundle.main).instantiateViewController(withIdentifier: "InviteFriendVC") as? InviteFriendVC
              
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            else if indexPath.row == 2{
                
                //History
                Global.addFirebaseEvent(eventName: "my_history_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.myHistoryClick, param: [:])
                self.performSegue(withIdentifier: "HistoryVC", sender: nil)
            }
            else if indexPath.row == 3{
                //Offer
                self.performSegue(withIdentifier: "MyOfferVC", sender: nil)
                
            }
            else if indexPath.row == 4{
                //woloo gift card
                Global.addFirebaseEvent(eventName: "woloo_gift_card_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.wolooGiftCardClick, param: [:])
                self.performSegue(withIdentifier: "AddGiftCardVC", sender: nil)
                
            }
            else if indexPath.row == 5{
                //Become a woloo host
                
                Global.addFirebaseEvent(eventName: "become_host_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.becomeHostClick, param: [:])
                
                self.performSegue(withIdentifier: "BecomeHostVC", sender: nil)
            }
            else if indexPath.row == 6{
                //refer_host_click
                Global.addFirebaseEvent(eventName: "refer_host_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.referHostClick, param: [:])
                self.performSegue(withIdentifier: "ReferHostVC", sender: true)
                
            }
            else if indexPath.row == 7{
                //About
                Global.addFirebaseEvent(eventName: "about_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.aboutClick, param: [:])
                self.performSegue(withIdentifier: "AboutVC", sender: nil)
                
            }
            else if indexPath.row == 8{
                //terms Of use
                Global.addFirebaseEvent(eventName: "terms_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.termsClick, param: [:])
                self.performSegue(withIdentifier: "TermsVC", sender: nil)
                
            }
            else if indexPath.row == 9{
                //log out
                Global.showOkCancelAlertMessage(title: "Confirm", message: AppConfig.getAppConfigInfo()?.customMessage?.logoutDialog ?? "") { (isOK, isCancel) in
                    if isOK {
                        Global.addFirebaseEvent(eventName: "logout_click", param: [:])
                        Global.addNetcoreEvent(eventname: self.netcoreEvents.userLogoutSuccess, param: [:])
                        Global.addNetcoreEvent(eventname: self.netcoreEvents.logoutClick, param: [:])
                        Hansel.getUser()?.clear()
                        UserDefaultsManager.isUserloggedInStatusSave(value: false)
                        UserModel.setUserLoggedInStatus(status: false)
                        UserDefaults.userTransportMode = nil
                        UserModel.resetUserData()
                        UserDefaults.standard.resetDefaults()
                        UserDefaults.tutorialScreen = true
                        Global.shared.launchAuthBoard()
                        //Delay to call system event of netcore
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                            Smartech.sharedInstance().logoutAndClearUserIdentity(true)
    //                        Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                            
                        }
                        //Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                        //have to add the delay of one second
                        
                        
                    }
                }
                
            }
            
        }
    }
}
