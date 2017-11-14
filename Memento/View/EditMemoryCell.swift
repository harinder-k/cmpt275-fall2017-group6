//
//  EditMemoryCell.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-11.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class EditMemoryCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = UIColor(r: 230, g: 235, b: 240)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var setting: SettingEditMemorryPage? {
        didSet {
            nameLable.text = setting?.labelName
            imageIcon.image = UIImage(named: (setting?.iconName)!)
        }
    }
    let nameLable : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageIcon : UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "add_icon")
        /*
         Source : https://www.materialui.co/icon/add-circle-outline
         */
        icon.contentMode = .scaleAspectFill
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
  
    func setupViews() {
        self.addSubview(nameLable)
        self.addSubview(imageIcon)
        
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-52-[v0(30)]-52-[v1]-52-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageIcon, "v1": nameLable])
        let v0Constraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLable])
        let v1Constraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(30)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageIcon])
        
        
        NSLayoutConstraint.activate(hConstraint)
        NSLayoutConstraint.activate(v0Constraint)
        NSLayoutConstraint.activate(v1Constraint)
        addConstraint(NSLayoutConstraint(item: imageIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}
