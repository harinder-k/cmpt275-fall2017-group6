//
//  EditStoryViewController.swift
//  Memento
//
//  Created by hkhakh on 10/30/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit

class EditStoryViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var timeLineView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //nothing has been done yet
        var memory: UICollectionViewCell = UICollectionViewCell()
        
        return memory
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //nothing has been done yet
        return 5
    }
    
}
