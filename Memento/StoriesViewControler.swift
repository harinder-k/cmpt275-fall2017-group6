//
//  StoriesViewControler.swift
//  Memento
//
//  Created by hkhakh on 10/27/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit

class StoriesViewController:UIViewController {
    
    
    @IBAction func NewStoryButton(_ sender: Any) {
        let storyNameAlert = UIAlertController(title: "Create A New Story", message: "What would like like to call your story?", preferredStyle: UIAlertControllerStyle.alert)
        
        storyNameAlert.addTextField { (textField) in textField.text = "Name"
        }
        let moveToCreateStory = UIAlertAction(title: "Okay", style: .default){
            [weak storyNameAlert] (_) in let textField = storyNameAlert?.textFields![0]
        }
        
        storyNameAlert.addAction(moveToCreateStory)
        
        self.present(storyNameAlert, animated: true){
            () -> Void in print("alert presented")
        }
        self.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
