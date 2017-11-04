//File Name: TakeQuizViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhi, Harinder
//Version 1.2
//Changes:
//1.0 - Created file and added title using stringOassed
//1.1 - Mapped buttons to functions and implemented basic quiz
//1.2 - Implemented quiz
//Known bugs:


import Foundation
import UIKit

struct QuizQuestion {
    var question: String
//    var imageName: String
    var options = [String]()
    var answer: String
}

class TakeQuizViewController:UIViewController {
    let titleEnd = " Quiz"
    let correctAnswerMessage = "Correct Answer!"
    let wrongAnswerMessage = "Wrong Answer"
    let numberOfQuestions = 5
    
    var correctAnswer = ""
    
    var quizName = ""                                                                           // set by QuizVieeController based on which button is passed
    var questionNum = -1
    var numCorrectAnswers = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!                                                  // to inform the user whether or not their answer was correct
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    lazy var optionButtons: [UIButton] = [self.option1Button, self.option2Button, self.option3Button, self.option4Button]
    
    @IBOutlet weak var nextButton: UIButton!
    
    var quiz = [QuizQuestion]()                                                                 // array of structs to hold quiz content
    
    let animalQuestions = ["What is the fastest land animal?", "What is the tallest animal?", "What is a group of lions called?", "How many legs does a spider have?", "Which of the following animals is a herbivore?"]
    
    let animalOptions = [["Deer", "Cougar", "Cheetah", "Penguin"], ["Antelope", "Giraffe", "Horse", "Ostrich"], ["Pride", "Gang", "School", "Pack"], ["4", "6", "7", "8"], ["Bear", "Fox", "Frog", "Elephant"]]
    
    let animalAnswers = ["Cheetah", "Giraffe", "Pride", "8", "Elephant"]
    
    let geographyQuestions = ["Which country has the highest population?", "What is the capital of Spain?", "In which city is the Eiffel Tower located?", "Which country is the largest by land area?", "What is the biggest continent on Earth?"]
    
    let geographyOptions = [["India", "China", "United States of America", "Japan"], ["Madrid", "Seville", "Barcelona", "Valencia"], ["London", "Tokyo", "New York", "Paris"], ["Canada", "United States of America", "Russia", "China"], ["Africa", "Asia", "North America", "Antarctica"]]
    
    let geographyAnswers = ["China", "Madrid", "Paris", "Russia", "Aaia"]
    
    let famousPeopleQuestions = ["Who is the current president of the United States of America?", "Who invented the telephone?", "Which famous celebrity has the nickname 'The Rock'?", "Who discovered gravity?", "Who was the first person to walk on the moon?"]
    
    let famousPeopleOptions = [["Barack Obama", "Donald Trump", "Bill Clinton", "George W. Bush"], ["Nikola Tesla", "Thomas Edison", "Alenxander Graham Bell", "Alan Turing"], ["Dwayne Johnson", "Jason Statham", "Vin Diesel", "Matt Damon"], ["Albert Einstein", "Isaac Newton", "Neils Bohr", "Charles Darwin"], ["Buzz Aldrin", "Charles Conrad", "Alan Shepard", "Neil Armstrong"]]
    
    let famousPeopleAnswers = ["Donald Trump", "Alenxander Graham Bell", "Dwayne Johnson", "Isaac Newton", "Neil Armstrong"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quizName + titleEnd
        
        makeQuiz()
//        extractFromJson()
        askQuestion()
    }
    
    // Precondition:    Quiz content is available
    // Postcondition:   Quiz content is arranged into array of structs
    func makeQuiz() {
        if quizName == "Animals" {
            for i in 0...4 {
                quiz.append(QuizQuestion(question: animalQuestions[i], options: animalOptions[i], answer: animalAnswers[i]))
            }
        } else if quizName == "Geography" {
            for i in 0...4 {
                quiz.append(QuizQuestion(question: geographyQuestions[i], options: geographyOptions[i], answer: geographyAnswers[i]))
            }
        } else if quizName == "Famous People"{
            for i in 0...4 {
                quiz.append(QuizQuestion(question: famousPeopleQuestions[i], options: famousPeopleOptions[i], answer: famousPeopleAnswers[i]))
            }
        }
    }
    
    // Precondition:    THe user has not yet answered the question
    // Postcondition:   Feedback label and Next button are hidden from the user
    //                  and the option buttions are enabled
    func unansweredState() {
        for aButton in optionButtons {
            aButton.isEnabled = true
        }
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
    }
    
    // Precondition:    The user has answered the question
    // Postcondition:   Feedback label and Next (or Finish) button are visible to the user
    //                  and the option buttons are disabled
    func answeredState() {
        for aButton in optionButtons {
            aButton.isEnabled = false
        }
        if questionNum == numberOfQuestions - 1 {
            nextButton.setTitle("Finish", for: UIControlState.normal)
        }
        feedbackLabel.isHidden = false
        nextButton.isHidden = false
    }
    
    // Precondition:    The user has pressed the Finish button
    // Postcondition:   All objects are hidden and result is shown
    func finishedState() {
        questionLabel.isHidden = true
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
        
        for aButton in optionButtons {
            aButton.isHidden = true
        }
        resultLabel.text = "You answered \(numCorrectAnswers) out of \(numberOfQuestions) questions correctly."
    }
    
    // Precondition:    A json file exists for the appropriate quiz and is well structured
    // Postcondition:   Quiz data is read from the json file
//    func extractFromJson(){
//        if let quizFilePath = Bundle.main.path(forResource: "Animals", ofType: "rtf", inDirectory: "Quiz"){
//            do {
//                let data = try Data(contentsOf : URL(fileURLWithPath: quizFilePath), options: .alwaysMapped)
//                let decoder = JSONDecoder()
//                let questions = try? decoder.decode([QuizQuestion].self, from: data)
//                print(questions![0].answer)
//                question = questions![0].question
//                NSLog(question)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        } else {
//            print("Invalid filename/path.")
//        }
//    }
    
    // Precondition:    There are questions left to be answered
    // Postcondition:   The question, image (if applicanle) and options are visible to the user
    func askQuestion() {
        unansweredState()
        questionNum = questionNum + 1
        questionLabel.text = quiz[questionNum].question
        option1Button.setTitle(quiz[questionNum].options[0], for: UIControlState.normal)
        option2Button.setTitle(quiz[questionNum].options[1], for: UIControlState.normal)
        option3Button.setTitle(quiz[questionNum].options[2], for: UIControlState.normal)
        option4Button.setTitle(quiz[questionNum].options[3], for: UIControlState.normal)
        
        correctAnswer = quiz[questionNum].answer
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option1ButtonTapped(_ sender: Any) {
        if correctAnswer == option1Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option2ButtonTapped(_ sender: Any) {
        if correctAnswer == option2Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option3ButtonTapped(_ sender: Any) {
        if correctAnswer == option3Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option4ButtonTapped(_ sender: Any) {
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    The next button is tapped
    // Postcondition:   If there are more questions left, the next question is shown
    //                  If all questions have been asked, the result screen is shown
    @IBAction func nextButtonTapped(_ sender: Any) {
        if questionNum == numberOfQuestions - 1 {
            finishedState()
        } else {
            askQuestion()
        }
    }
}
