// File Name: QuizzesViewController.swift
// Team Name: MemTech
// Group number: Group 6
// Developers: Harinder
// Version 1.0
// Changes:
// 1.0 - Created file and functionality to buttons
// Known bugs:

import Foundation
import UIKit

class QuizzesViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Precondition: Animals Button is tapped
    // Postcondition: Animals Quiz is loaded
    @IBAction func animalsButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = "Animals"
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
    
    // Precondition: Geography Button is tapped
    // Postcondition: Geography Quiz is loaded
    @IBAction func geographyButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = "Geography"
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
    
    // Precondition: Famous People Button is tapped
    // Postcondition: Famous People Quiz is loaded
    @IBAction func famousPeopleButtonTapped(_ sender: Any) {
        let takeQuizVC = storyboard?.instantiateViewController(withIdentifier: "TakeQuizViewController") as! TakeQuizViewController
        takeQuizVC.quizName = "Famous People"
        navigationController?.pushViewController(takeQuizVC, animated: true)
    }
}


