// File Name: QuizzesViewController.swift
// Team Name: MemTech
// Group number: Group 6
// Developers: Harinder
// Version 1.0
// Changes:
// 1.0 - Created file and functionality to buttons
// 1.1 - Started personal quizzes implementation
// Known bugs: Personal quizzes buttons do not yet work

import Foundation
import UIKit

class QuizzesViewController:UIViewController {
    
    var personalQuizTypeSelected = false                                                                                                   // 0 denotes general quizzes and 1 denotes personal quizzes
    
    @IBOutlet weak var quizTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstQuizButton: UIButton!
    @IBOutlet weak var secondQuizButton: UIButton!
    @IBOutlet weak var thirdQuizButton: UIButton!
    
    let generalQuizTypes = ["Animals", "Geography", "Famous People"]
    let personalQuizTypes = ["People", "Places", "Dates"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeQuizType() {
        if !personalQuizTypeSelected {
            firstQuizButton.setTitle(generalQuizTypes[0], for: UIControlState.normal)
            secondQuizButton.setTitle(generalQuizTypes[1], for: UIControlState.normal)
            thirdQuizButton.setTitle(generalQuizTypes[2], for: UIControlState.normal)
        } else {
            firstQuizButton.setTitle(personalQuizTypes[0], for: UIControlState.normal)
            secondQuizButton.setTitle(personalQuizTypes[1], for: UIControlState.normal)
            thirdQuizButton.setTitle(personalQuizTypes[2], for: UIControlState.normal)
        }
    }
    
    @IBAction func quizTypeValueChanged(_ sender: Any) {
        personalQuizTypeSelected = (quizTypeSegmentedControl.selectedSegmentIndex == 1)
        changeQuizType()
    }
    
    // Precondition: First button is tapped
    // Postcondition: Quiz with first button's label is loaded
    @IBAction func firstQuizButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = (firstQuizButton.titleLabel?.text)!
        takeQuizVC.personalQuizSelected = personalQuizTypeSelected
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
    
    // Precondition: Second button is tapped
    // Postcondition: Quiz with second button's label is loaded
    @IBAction func secondQuizButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = (secondQuizButton.titleLabel?.text)!
        takeQuizVC.personalQuizSelected = personalQuizTypeSelected
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
    
    // Precondition: Third button is tapped
    // Postcondition: Quiz with third button's label is loaded
    @IBAction func thirdQuizButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = (thirdQuizButton.titleLabel?.text)!
        takeQuizVC.personalQuizSelected = personalQuizTypeSelected
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
}


