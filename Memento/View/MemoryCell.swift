//
//  MemoryCell.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-11.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
class MemoryCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var image: UIImage? {
        didSet {
            if let newImage = image {
                thumbnailImageView.image = newImage
            }
        }
    }
    
    let thumbnailImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "add_photo")
        /*
         images source : https://www.iconfinder.com/icons/213524/add_image_new_photo_photograph_photography_picture_icon
         */
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupViews() {
        self.addSubview(thumbnailImageView)
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView])
        let vConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView])
        
        NSLayoutConstraint.activate(hConstraint)
        NSLayoutConstraint.activate(vConstraint)
    }
}
