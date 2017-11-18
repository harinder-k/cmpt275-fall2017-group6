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
    @IBOutlet weak var testTextField: UITextField!
    
    let reuseIdentifier = "cell"
    var timelineData: [Memory] = []
    var chatchMemData = Memory()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testTextField.text = chatchMemData?.name
        timelineData.append(chatchMemData!)
        
    }
    
    // @Tim: Update collectionView + Memory array inside this function
    @IBAction func AddMemoryButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segAddMem", sender: self)
    }
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.cellImage.image = timelineData[indexPath.item].photos[0].image
 
        cell.cellImage.image = #imageLiteral(resourceName: "add_photo")
        
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    //For debugging
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}


import UIKit
class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
}
