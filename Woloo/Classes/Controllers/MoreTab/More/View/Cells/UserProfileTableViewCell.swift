//
//  UserProfileTableViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 24/10/24.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var vwBackMembership: UIView!
    @IBOutlet weak var vwBackNumber: UIView!
    @IBOutlet weak var vwBackCity: UIView!
    @IBOutlet weak var vwBackGender: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var mobileno: UILabel!
    @IBOutlet weak var wolooPointLbl: UILabel!
    @IBOutlet weak var wolooPremimumLbl: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnOpenImagePicker: UIButton!
    @IBOutlet weak var btnOpenMyAccount: UIButton!
    
    var editProfileClickEvent: (() -> Void)?
    var editProfilePicClickEvent: (() -> Void)?
    var openAccountClickEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.cornerRadius = 25.0
        self.vwBackMembership.cornerRadius = 5.0
        self.vwBackNumber.cornerRadius = 5.0
        self.vwBackCity.cornerRadius = 5.0
        self.vwBackGender.cornerRadius = 5.0
        
    }

    func configureUserProfileTableViewCell(objUser: MoreTabDetailV2?){
      
        let name = objUser?.userData?.name?.capitalized ?? ""
        self.nameLbl.text = name.isEmpty ? "Guest" : name
        
        // mobile
        let mobileNumber = String(objUser?.userData?.mobile ?? 0)
        self.mobileno.text = mobileNumber.isEmpty ? "" : mobileNumber

        // gender
        let gender = objUser?.userData?.gender ?? ""
        self.lblGender.text = gender.isEmpty ? "Female" : gender
        
        // city
        let city = objUser?.userData?.city ?? ""
        self.locationLbl.text = city.isEmpty ? "" : city

        if let avtar = objUser?.userData?.avatar, avtar.count > 0 {
            let url = "\(objUser?.userData?.baseUrl ?? "")\(avtar)"
            self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            //            self.profileImageView.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.profileImageView.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
        }
        
        // point & subscription
        self.wolooPointLbl.text = "\(objUser?.userCoin?.total_coins ?? 0) Woloo Points"
        
        if let expiryDatestr = objUser?.userData?.expiry_date  {
            let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd")
            var dayComponent    = DateComponents()
            dayComponent.day    = 0
             let theCalendar     = Calendar.current
            let e2        = theCalendar.date(byAdding: dayComponent, to: expiryDate)
            let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
            if days < 0 {
                    self.wolooPremimumLbl.text = "Membership Expired"
            } else {
                if objUser?.subscriptionData?.name?.count ?? 0 > 0 {
                    self.wolooPremimumLbl.text = objUser?.subscriptionData?.name?.uppercased()
                }
                else if Utility.isEmpty(objUser?.subscriptionData?.name ?? ""){
                    self.wolooPremimumLbl.text = "FREE TRIAL"
                }
            }
        }
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        editProfileClickEvent?()
    }
    @IBAction func editProfilePicButtonAction(_ sender: Any) {
        editProfilePicClickEvent?()
    }
    
    
    @IBAction func clickedOpenMyAccount(_ sender: UIButton) {
        openAccountClickEvent?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
