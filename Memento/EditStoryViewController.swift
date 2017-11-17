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
    var timelineData: [MemoryData] = []
    var chatchMemData: MemoryData = MemoryData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // @Tim: Update collectionView + Memory array inside this function
    @IBAction func AddMemoryButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "segAddMem", sender: self)
        
        /*
        // Need this to get memory back from MemoryViewController
        let memoryViewController = storyboard?.instantiateViewController(withIdentifier: "MemoryViewController") as! MemoryViewController
        
        memoryViewController.completionHandler = { newMemory in
            
            print("name = \(newMemory.name)")
            print("photos = \(newMemory.photos.count)")
            return newMemory.photos.count
        }
        navigationController?.pushViewController(memoryViewController, animated: true)
        */
    }
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //nothing has been done yet
        let memoryCell = UICollectionViewCell()
        //var memory: UICollectionViewCell = UICollectionViewCell()
        //let memoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewMemoryCell
        
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

//Variable for each memory in the timeline
class MemoryData {
    
    var images: [UIImage] = []
    var memTitle: String
    var addedText: String
    
    init() {
        memTitle = "My day"
        addedText = "I had lots of fun!"
    }
    
}
