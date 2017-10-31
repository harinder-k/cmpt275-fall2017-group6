//
//  QuizzesViewController.swift
//  Memento
//
//  Created by hkhakh on 10/27/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit

class QuizzesViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func animalsButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.stringPassed = "Animals Quiz"
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
}


