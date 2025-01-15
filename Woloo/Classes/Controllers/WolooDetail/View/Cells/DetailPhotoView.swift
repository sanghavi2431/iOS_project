//
//  DetailPhotoView.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/11/24.
//

import UIKit

class DetailPhotoView: UITableViewCell {


    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoList: [String]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var baseUrlImage: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DetailPhotoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupView() {
        print("Image list: \(photoList?.count)")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        fillCell(cell,indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width/3, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

// MARK: - Cell Handling
extension DetailPhotoView {
    private func fillCell(_ cell: ImageCell, _ indexPath: IndexPath) {
        
        
        if photoList?.count == 0{
            cell.imageView.image = #imageLiteral(resourceName: "woloo_default")
            
        }else{
            //https://admin.woloo.in/storage/app/public/woloos/January2022/eoeiW9fJLC8NsFm5UWWT.jpg
            print("photoList: \(photoList?[0] ?? "")")
            let url = "https://api.woloo.in/\(photoList)"
            
            
            print("Image Array: \(url)")
            
            for url1 in photoList!{
                
                var finalUrlImage = "\(baseUrlImage ?? "")/\(url1 ?? "")"
                
                print("finalUrlImage: \(finalUrlImage)")
                
                cell.imageView.sd_setImage(with: URL(string: finalUrlImage), completed: nil)
            }
            
            //cell.imageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        
//            if let imageURL = self.photoList?[indexPath.item] {
//                let url = "\(API.environment.baseURL)/storage/app/public/\(imageURL)"
//                //cell.imageView.sd_setImage(with: URL(string: url), completed: nil)
//                cell.imageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "woloo_default"), options: .continueInBackground, context: [:])
//            } else {
//                cell.imageView.image = #imageLiteral(resourceName: "woloo_default")
//            }
        cell.buttonView.isHidden = true
        cell.imageView.contentMode = .scaleToFill
       // cell.imageView.backgroundColor = .lightGray
        cell.imageView.cornerRadius = 20
        cell.plusPlaceHolderImage.isHidden = true
        cell.deleteButton.isHidden = true
    }
}
