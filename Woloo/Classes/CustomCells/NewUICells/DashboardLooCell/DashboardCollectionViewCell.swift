//
//  DashboardCollectionViewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/10/24.
//

import UIKit

protocol DashboardCollectionViewCellDelegate: NSObjectProtocol
{
    func didClickedNavigate(obj: NearbyResultsModel)
}

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgViewWoloo: UIImageView!
    @IBOutlet weak var lblWolooTitle: UILabel!
    @IBOutlet weak var lblWolooAddress: UILabel!
    @IBOutlet weak var vwBackCibil: UIView!
    @IBOutlet weak var btnNavigate: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblCibilScore: UILabel!
    
    // @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    weak var delegate: DashboardCollectionViewCellDelegate?
    var objobjNearbyResultsModel = NearbyResultsModel()
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewWoloo.cornerRadius = 21.0
        self.vwBackCibil.cornerRadius = 18.0
        self.vwBack.cornerRadius = 20.0
    }

    func configureDashboardCollectionViewCell(objNearbyResultsModel : NearbyResultsModel?){
        self.objobjNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        self.lblWolooTitle.text = self.objobjNearbyResultsModel.name ?? ""
        self.lblWolooAddress.text = self.objobjNearbyResultsModel.address ?? ""
        
        let url = "\(objobjNearbyResultsModel.base_url ?? "")/\(objobjNearbyResultsModel.image?[0] ?? "")"
        let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
        self.imgViewWoloo.sd_setImage(with: URL(string: trimmedUrl), completed: nil)
        
        self.lblDistance.text =  "\(self.objobjNearbyResultsModel.distance ?? "")"
        self.lblTime.text = "\(self.objobjNearbyResultsModel.duration ?? "")"
        self.lblCibilScore.text = self.objobjNearbyResultsModel.cibil_score ?? ""
        
    }
    
    
    @IBAction func clickedBtnNavigate(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedNavigate(obj: self.objobjNearbyResultsModel)
        }
    }
    
}
