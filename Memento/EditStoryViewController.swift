//
//  EditStoryViewController.swift
//  Memento
//
//  Created by hkhakh on 10/30/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class EditStoryViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var timeLineView: UICollectionView!
    let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // @Tim: Update collectionView + Memory array inside this function
    @IBAction func AddMemoryButtonPressed(_ sender: Any) {
        // Need this to get memory back from MemoryViewController
        let memoryViewController = storyboard?.instantiateViewController(withIdentifier: "MemoryViewController") as! MemoryViewController
        
        memoryViewController.completionHandler = { newMemory in
            
            print("name = \(newMemory.name)")
            print("photos = \(newMemory.photos.count)")
            return newMemory.photos.count
        }
        navigationController?.pushViewController(memoryViewController, animated: true)
    }
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //nothing has been done yet
        //var memory: UICollectionViewCell = UICollectionViewCell()
        let memoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewMemoryCell
        
        //memoryCell.image = 
        
        return memoryCell
    }
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //nothing has been done yet
        return 5
    }
    
    //For debugging
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}

//Memory Cell Class
class MyCollectionViewMemoryCell: UICollectionViewCell {
    
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
