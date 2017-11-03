//File Name: TakeQuizViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhi, Harinder
//Version 1.1
//Changes:
//1.0 - Created file and added title using stringOassed
//1.1 - Mapped buttons to functions and implemented basic quiz
//Known bugs: Minor bug: Crashes the app


import Foundation
import UIKit

struct QuizQuestion:Decodable {
    var question: String
    var image: String
    var options = [String]()
    var answer: String
}

class TakeQuizViewController:UIViewController {
    let titleEnd = " Quiz"
    let correctAnswerMessage = "Correct Answer!"
    let wrongAnswerMessage = "Wrong Answer"
    let numberOfQuestions = 5
    
    var question = ""
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""
    
    
    var quizName = ""                                                                           // set by QuizVieeController based on which button is passed
    var questionNum = 0
    //var questionNumsUsed = [Int]()
    var correctAnswer = ""
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quizName + titleEnd
        
        //randomizeQuestionNumber()
        extractFromJson()
        askQuestion()
    }
    
    func answered() {
        feedbackLabel.isHidden = false
        nextButton.isHidden = false
    }
    
    func unanswered() {
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
    }
    /*
    func randomizeQuestionNumber() {
        questionNum = Int(arc4random_uniform(UInt32(numberOfQuestions))) + 1
        for questionNumUsed in questionNumsUsed {
            while questionNum == questionNumUsed {
                questionNum = Int(arc4random_uniform(UInt32(numberOfQuestions))) + 1
            }
        }
    }
    */
    
    
    func extractFromJson(){
        if let quizFilePath = Bundle.main.path(forResource: quizName, ofType: "json", inDirectory: "Quiz"){
            do{
                let data = try Data(contentsOf : URL(fileURLWithPath: quizFilePath), options: .alwaysMapped)
                let decoder = JSONDecoder()
                let questions = try? decoder.decode([QuizQuestion].self, from: data)
            }catch let error{
                print(error.localizedDescription)
            }
        }else {
            print("Invalid filename/path.")
        }
    }
    
    func askQuestion() {
        
        unanswered()
        questionNum = questionNum + 1
        questionLabel.text = question
        option1Button.setTitle(option1, for: UIControlState.normal)
        option2Button.setTitle(option2, for: UIControlState.normal)
        option3Button.setTitle(option3, for: UIControlState.normal)
        option4Button.setTitle(option4, for: UIControlState.normal)
    }
    
    @IBAction func option1ButtonTapped(_ sender: Any) {
        answered()
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option2ButtonTapped(_ sender: Any) {
        answered()
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option3ButtonTapped(_ sender: Any) {
        answered()
        if correctAnswer == option3 {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func option4ButtonTapped(_ sender: Any) {
        answered()
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
}
