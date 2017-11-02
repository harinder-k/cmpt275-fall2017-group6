//File Name: TakeQuizViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhi, Harinder
//Version 1.1
//Changes:
//1.0 - Created file and added title using stringOassed
//1.1 - Mapped buttons to functions
//Known bugs: Minor bug: Crashes the app


import Foundation
import UIKit

class TakeQuizViewController:UIViewController {
    let titleEnd = " Quiz"
    let correctAnswerMessage = "Correct Answer!"
    let wrongAnswerMessage = "Wrong Answer"
    let numberOfQuestions = 5
    
    var quizName = ""                                                                           // set by QuizVieeController based on which button is passed
    var questionNum = 0
    var questionNumsUsed = [Int]()
    var correctAnswer = ""
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quizName + titleEnd
        
        randomizeQuestionNumber()
        askQuestion()
    }
    
    func randomizeQuestionNumber() {
        questionNum = Int(arc4random_uniform(UInt32(numberOfQuestions))) + 1
        for questionNumUsed in questionNumsUsed {
            while questionNum == questionNumUsed {
                questionNum = Int(arc4random_uniform(UInt32(numberOfQuestions))) + 1
            }
        }
    }
    
    func askQuestion() {
        questionLabel.text = "Pick C"
        option1Button.setTitle("A", for: UIControlState.normal)
        option2Button.setTitle("B", for: UIControlState.normal)
        option3Button.setTitle("C", for: UIControlState.normal)
        option4Button.setTitle("D", for: UIControlState.normal)
        
        correctAnswer = "C"
    }
    
    @IBAction func option1ButtonTapped(_ sender: Any) {
        if correctAnswer == option1Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option2ButtonTapped(_ sender: Any) {
        if correctAnswer == option2Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option3ButtonTapped(_ sender: Any) {
        if correctAnswer == option3Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option4ButtonTapped(_ sender: Any) {
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
}
