//
//  CollectionViewCell.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/12/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //  name.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
       
    }

    public func configure(with imageURL: String, within title: String ){
        imageView.kf.setImage(with: URL(string:imageURL))
        name.text = title
      
    
        
    }
    
    static func NIB() -> UINib{
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    
}
