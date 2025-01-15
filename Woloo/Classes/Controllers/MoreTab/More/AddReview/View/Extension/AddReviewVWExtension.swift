//
//  AddReviewVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import Foundation
import UIKit

extension AddReviewVC: UITableViewDelegate, UITableViewDataSource{
    
   
    
    //MARK: - UITableviewdelegate and data source mthods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell: AddReviewCibilImgViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewCibilImgViewCell") as! AddReviewCibilImgViewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewCibilImgViewCell", owner: self, options: nil)?.last as? AddReviewCibilImgViewCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            var cell: AddReviewSliderCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSliderCell") as! AddReviewSliderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSliderCell", owner: self, options: nil)?.last as? AddReviewSliderCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 2 {
            var cell: AddReviewSeparatorCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSeparatorCell") as! AddReviewSeparatorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSeparatorCell", owner: self, options: nil)?.last as? AddReviewSeparatorCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 3 {
            var cell: AddReviewStarCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewStarCell") as! AddReviewStarCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewStarCell", owner: self, options: nil)?.last as? AddReviewStarCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 4 {
            var cell: AddReviewDescriptionCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewDescriptionCell") as! AddReviewDescriptionCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewDescriptionCell", owner: self, options: nil)?.last as? AddReviewDescriptionCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 5 {
            var cell: AddReviewSubmitBtnCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSubmitBtnCell") as! AddReviewSubmitBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSubmitBtnCell", owner: self, options: nil)?.last as? AddReviewSubmitBtnCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
    
        }
        return UITableViewCell()
    }
}
