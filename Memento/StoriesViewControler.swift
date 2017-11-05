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
        //Notification:
        let storyNameAlert = UIAlertController(title: "Create A New Story", message: "What would like like to call your story?", preferredStyle: UIAlertControllerStyle.alert)
        
        storyNameAlert.addTextField { (textField) in textField.text = "Name"
        }
        
        storyNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak storyNameAlert] (_) in
            let textField = storyNameAlert?.textFields![0]
        }))
        
        self.present(storyNameAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
