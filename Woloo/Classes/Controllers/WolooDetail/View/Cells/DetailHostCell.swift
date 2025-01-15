//
//  DetailHostCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

protocol DetailHostCellDelegate: NSObjectProtocol{
    
    func didSelectNavigationBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    func didSelectBookmamrkBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    func didSelectShareBtn(objNearbyResultsModel: NearbyResultsModel?)
    
    
}

class DetailHostCell: UITableViewCell {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblLocationAddress: UILabel!
    @IBOutlet weak var lbldistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var btnNavigation: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    
    var objNearbyResultsModel = NearbyResultsModel()
    var delegate : DetailHostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.roundCorners(corners: [.topLeft], radius: 20.0)
        
        
    }
    
    func configureDetailHostCell(objNearbyResultsModel: NearbyResultsModel?){
        
        self.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        self.lblLocationAddress.text = self.objNearbyResultsModel.address ?? ""
        self.lblHostName.text = self.objNearbyResultsModel.name ?? ""
        
        self.lbldistance.text = self.objNearbyResultsModel.distance ?? ""
        
        self.lblTime.text = self.objNearbyResultsModel.duration ?? ""
        
        if self.objNearbyResultsModel.is_liked == 1{
            self.btnBookmark.isSelected = true
            self.btnBookmark.backgroundColor = UIColor(named: "gray_selected_button_color")
          
        }
        else if self.objNearbyResultsModel.is_liked == 0{
            self.btnBookmark.isSelected = false
            self.btnBookmark.backgroundColor = UIColor(named: "yellow_button_color")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedNavigationBtn(_ sender: Any) {
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectNavigationBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
    
    @IBAction func clickedShareBtn(_ sender: Any) {
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectShareBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
    
    @IBAction func clickedBookmarkBtn(_ sender: Any) {
        self.btnBookmark.isSelected = !self.btnBookmark.isSelected
       
        if self.btnBookmark.isSelected == true
        {
            self.objNearbyResultsModel.is_liked = 1
        }
        else  if self.btnBookmark.isSelected == false{
            self.objNearbyResultsModel.is_liked = 0
        }
        
        
        if ((self.delegate) != nil){
            self.delegate?.didSelectBookmamrkBtn(objNearbyResultsModel: self.objNearbyResultsModel)
        }
        
    }
}
